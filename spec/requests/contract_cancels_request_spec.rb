require 'rails_helper'

RSpec.describe 'ContractCancels', type: :request do
  describe 'GET #index(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、解約一覧ページが表示される' do
      it 'indexアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get user_contract_cancels_path(@user)
        expect(response.status).to eq(200)
      end

      it 'indexアクションにリクエストすると、レスポンスに解約したサブスクの文字が存在する' do
        get user_contract_cancels_path(@user)
        expect(response.body).to include('解約したサブスク')
      end

      it 'indexアクションにリクエストすると、レスポンスに解約済のサブスク名が存在する' do
        get user_contract_cancels_path(@user)
        expect(response.body).to include(@subs.name)
      end

      it 'indexアクションにリクエストすると、レスポンスに解約済でないサブスク名は存在しない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        get user_contract_cancels_path(@user)
        expect(response.body).not_to include(subs.name)
      end

      it 'indexアクションにリクエストすると、レスポンスに解約日が存在する' do
        get user_contract_cancels_path(@user)
        cancel_date = @cancel.cancel_date
        year = cancel_date.year
        month = cancel_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = cancel_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day}")
      end
    end

    context '他人の解約一覧ページに遷移しようとすると、マイページにリダイレクトする' do
      it 'indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get user_contract_cancels_path(user)
        expect(response.status).to eq(302)
      end

      it 'indexアクションにリクエストすると、レスポンスにマイページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get user_contract_cancels_path(user)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #index(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'indexアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get user_contract_cancels_path(user)
        expect(response.status).to eq(302)
      end

      it 'indexアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get user_contract_cancels_path(user)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #new(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスク解約ページが表示される' do
      it 'newアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get new_user_subscription_contract_cancel_path(@user, @subs)
        expect(response.status).to eq(200)
      end

      it 'newアクションにリクエストすると、レスポンスにサブスク名の解約の文字が存在する' do
        get new_user_subscription_contract_cancel_path(@user, @subs)
        expect(response.body).to include("#{@subs.name}の解約")
      end

      it 'newアクションにリクエストすると、レスポンスに解約するボタンが存在する' do
        get new_user_subscription_contract_cancel_path(@user, @subs)
        expect(response.body).to include('解約する')
      end
    end

    context '存在しないサブスクidでnewアクションにリクエストすると、マイページにリダイレクトする' do
      it 'newアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get new_user_subscription_contract_cancel_path(@user, @subs.id + 1)
        expect(response.status).to eq(302)
      end

      it 'newアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get new_user_subscription_contract_cancel_path(@user, @subs.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでnewアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'newアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get new_user_subscription_contract_cancel_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'newアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get new_user_subscription_contract_cancel_path(user, subs)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #new(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'newアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get new_user_subscription_contract_cancel_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'newアクションにリクエストすると、レスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get new_user_subscription_contract_cancel_path(user, subs)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'POST #create(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが解約される' do
      it 'createアクションのリクエストが成功すると、マイページへリダイレクトする' do
        post user_subscription_contract_cancels_path(@user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel)
        }
        expect(response.status).to eq(302)
      end

      it 'createアクションのリクエストが成功すると、レスポンスにマイページのURLが含まれる' do
        post user_subscription_contract_cancels_path(@user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end

      it 'createアクションのリクエストが成功すると、契約解除レコードが登録される' do
        expect { post user_subscription_contract_cancels_path(@user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel) }
        }.to change { ContractCancel.count }.by(1)
      end
    end

    context '存在しないサブスクidでcreateアクションにリクエストすると、マイページにリダイレクトする' do
      it 'createアクションにリクエストすると、HTTPステータス302が返ってくる' do
        post user_subscription_contract_cancels_path(@user, @subs.id + 1), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel) }
        expect(response.status).to eq(302)
      end

      it 'createアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        post user_subscription_contract_cancels_path(@user, @subs.id + 1), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel) }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでcreateアクションにリクエストを送る場合' do
      it '契約解除レコードのカウントは変わらず、マイページにリダイレクトする' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        expect { post user_subscription_contract_cancels_path(user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel) }
        }.to change { ContractCancel.count }.by(0)
        expect(response.status).to eq(302)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context 'サブスク登録が失敗する場合、契約解除ページにレンダーされる' do
      it 'createアクションのリクエストが失敗すると、HTTPステータスは200が返る' do
        post user_subscription_contract_cancels_path(@user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel, reason_id: 0)
        }
        expect(response.status).to eq(200)
      end

      it 'createアクションのリクエストが失敗すると、契約解除レコードのカウントは変化しない' do
        expect { post user_subscription_contract_cancels_path(@user, @subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel, reason_id: 0) }
        }.to change { ContractCancel.count }.by(0)
      end

      it 'createアクションのリクエストが失敗すると、レスポンスにエラーメッセージが含まれる' do
        post user_subscription_contract_cancels_path(@user, @subs, @cancel), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel, reason_id: 0)
        }
        expect(response.body).to include('解約理由を選択してください')
      end

      it 'createアクションのリクエストが失敗すると、レスポンスにサブスク名の解約の文字が存在する' do
        post user_subscription_contract_cancels_path(@user, @subs, @cancel), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel, reason_id: 0)
        }
        expect(response.body).to include("#{@subs.name}の解約")
      end

      it 'createアクションのリクエストが失敗すると、レスポンスに解約するボタンが存在する' do
        post user_subscription_contract_cancels_path(@user, @subs, @cancel), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel, reason_id: 0)
        }
        expect(response.body).to include('解約する')
      end
    end
  end

  describe 'POST #create(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'createアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        post user_subscription_contract_cancels_path(user, subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel)
        }
        expect(response.status).to eq(302)
      end

      it 'createアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        post user_subscription_contract_cancels_path(user, subs), params: {
          contract_cancel: FactoryBot.attributes_for(:contract_cancel)
        }
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end
end
