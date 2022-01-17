require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'GET #show(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスク詳細ページが表示される' do
      it 'showアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get user_subscription_path(@user, @subs)
        expect(response.status).to eq(200)
      end

      it 'showアクションにリクエストすると、レスポンスにサブスク名が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.name)
      end

      it 'showアクションにリクエストすると、レスポンスに価格が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.price.to_s)
      end

      it 'showアクションにリクエストすると、レスポンスに契約開始日が存在する' do
        get user_subscription_path(@user, @subs)
        contract_date = @subs.contract_date
        year = contract_date.year
        month = contract_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = contract_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day}")
      end

      it 'showアクションにリクエストすると、レスポンスに累計金額が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@renewal.total_price.to_s)
      end

      it 'showアクションにリクエストすると、レスポンスに累計契約期間が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@renewal.total_period.to_s)
      end

      it 'showアクションにリクエストすると、レスポンスに次回更新日が存在する' do
        get user_subscription_path(@user, @subs)
        next_update_date = @renewal.next_update_date
        year = next_update_date.year
        month = next_update_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = next_update_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day}")
      end

      it 'showアクションにリクエストすると、レスポンスにレビュー平均が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@review.review_rate.to_s)
      end

      it 'showアクションにリクエストすると、レスポンスにアクション平均が存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(@action.action_rate.to_s)
      end

      it 'showアクションにリクエストすると、レスポンスに編集ボタンが存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include('編集する')
      end

      it 'showアクションにリクエストすると、レスポンスに削除ボタンが存在する' do
        get user_subscription_path(@user, @subs)
        expect(response.body).to include('削除する')
      end

      it 'showアクションにリクエストすると、解約済のサブスクなら、レスポンスに解約理由が存在する' do
        cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
        get user_subscription_path(@user, @subs)
        expect(response.body).to include(cancel.reason.name)
      end
    end

    context '存在しないサブスクidでshowアクションにリクエストすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get user_subscription_path(@user, @subs.id + 1)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_path(@user, @subs.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでshowアクションにリクエストすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_path(user, subs)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #show(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_path(user, subs)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #new(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスク登録ページが表示される' do
      it 'newアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get new_user_subscription_path(@user)
        expect(response.status).to eq(200)
      end

      it 'newアクションにリクエストすると、レスポンスにサブスク登録の文字が存在する' do
        get new_user_subscription_path(@user)
        expect(response.body).to include('サブスク登録')
      end

      it 'newアクションにリクエストすると、レスポンスに登録するボタンが存在する' do
        get new_user_subscription_path(@user)
        expect(response.body).to include('登録する')
      end
    end

    context '他人のidでnewアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'newアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get new_user_subscription_path(user)
        expect(response.status).to eq(302)
      end

      it 'newアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        get new_user_subscription_path(user)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #new(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'newアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get new_user_subscription_path(user)
        expect(response.status).to eq(302)
      end

      it 'newアクションにリクエストすると、レスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get new_user_subscription_path(user)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'POST #create(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが登録される' do
      it 'createアクションのリクエストが成功すると、マイページへリダイレクトする' do
        post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: @user.id)
        }
        expect(response.status).to eq(302)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end

      it 'createアクションのリクエストが成功すると、サブスクレコードが登録される' do
        expect { post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: @user.id)
        }}.to change { Subscription.count }.by(1)
      end

      it 'createアクションのリクエストが成功すると、契約更新レコードが登録される' do
        expect { post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: @user.id)
        }
        }.to change { ContractRenewal.count }.by(1)
      end
    end

    context '他人のidでcreateアクションにリクエストを送る場合' do
      it 'Subscriptionカウントは変わらず、マイページにリダイレクトする' do
        user = FactoryBot.create(:user)
        expect { post user_subscriptions_path(user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: user.id)
        }
        }.to change { ContractRenewal.count }.by(0)
        expect(response.status).to eq(302)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context 'サブスク登録が失敗する場合' do
      it 'createアクションのリクエストが失敗すると、HTTPステータスは200が返る' do
        post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        expect(response.status).to eq(200)
      end

      it 'createアクションのリクエストが失敗すると、Subscriptionカウントは変化しない' do
        expect { post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        }.to change { Subscription.count }.by(0)
      end

      it 'createアクションのリクエストが失敗すると、ContractRenewalカウントは変化しない' do
        expect { post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        }.to change { ContractRenewal.count }.by(0)
      end

      it 'createアクションのリクエストが失敗すると、レスポンスにエラーメッセージが含まれる' do
        post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        expect(response.body).to include('価格を入力してください')
      end

      it 'createアクションのリクエストが失敗すると、レスポンスにサブスク登録の文字が存在する' do
        post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        expect(response.body).to include('サブスク登録')
      end

      it 'createアクションのリクエストが失敗すると、レスポンスに登録するボタンが存在する' do
        post user_subscriptions_path(@user), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: nil).merge(user_id: @user.id)
        }
        expect(response.body).to include('登録する')
      end
    end
  end

  describe 'POST #create(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'createアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        post user_subscriptions_path(user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: user.id)
        }
        expect(response.status).to eq(302)
      end

      it 'createアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        post user_subscriptions_path(user), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: user.id)
        }
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #edit(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスク編集ページが表示される' do
      it 'editアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.status).to eq(200)
      end

      it 'editアクションにリクエストすると、レスポンスにサブスク編集の文字が存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include('サブスク編集')
      end

      it 'editアクションにリクエストすると、レスポンスに更新するボタンが存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include('更新する')
      end

      it 'editアクションにリクエストすると、＊契約日を変更したいときの文字が存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include('＊契約日を変更したいとき')
      end

      it 'editアクションにリクエストすると、レスポンスにサブスク名が存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.name)
      end

      it 'editアクションにリクエストすると、レスポンスにサブスク価格が存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.price.to_s)
      end

      it 'editアクションにリクエストすると、レスポンスにサブスクの更新サイクル存在する' do
        get edit_user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.update_cycle.to_s)
      end
    end

    context '存在しないサブスクidでeditアクションにリクエストすると、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get edit_user_subscription_path(@user, @subs.id + 1)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get edit_user_subscription_path(@user, @subs.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでeditアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get edit_user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get edit_user_subscription_path(user, subs)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #edit(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get edit_user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get edit_user_subscription_path(user, subs)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'PATCH #update(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが更新される' do
      it 'updateアクションのリクエストが成功すると、HTTPステータス200が返ってくる' do
        patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription)
        }
        expect(response.status).to eq(200)
      end

      it 'updateアクションのリクエストが成功すると、サブスクレコードの値が更新される' do
        expect { patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: 123_45)
        }
        }.to change { Subscription.find(@subs.id).price }.from(@subs.price).to(123_45)
      end

      it 'updateアクションのリクエストが成功すると、レスポンスにfalseを含む' do
        patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription).merge(user_id: @user.id)
        }
        expect(response.body).to include('false')
      end
    end

    context '存在しないサブスクidでupdateアクションにリクエストすると、マイページにリダイレクトする' do
      it 'updateアクションにリクエストすると、HTTPステータス302が返ってくる' do
        patch user_subscription_path(@user, @subs.id + 1), params: {
          subscription: FactoryBot.attributes_for(:subscription)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        patch user_subscription_path(@user, @subs.id + 1), params: {
          subscription: FactoryBot.attributes_for(:subscription)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでupdateアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'updateアクションにリクエストを送ると、HTTPステータス302が返る' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        patch user_subscription_path(user, subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: 123_45)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストを送ると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        patch user_subscription_path(user, subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: 123_45)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context 'サブスク更新が失敗する場合' do
      it 'updateアクションのリクエストが失敗すると、HTTPステータスは200が返る' do
        patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: -1)
        }
        expect(response.status).to eq(200)
      end

      it 'updateアクションのリクエストが失敗すると、サブスクレコードの値は更新されない' do
        expect { patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: -1)
        }
        }.to_not change { Subscription.find(@subs.id).price }
      end

      it 'updateアクションのリクエストが失敗すると、レスポンスにtrueを含む' do
        patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: -1)
        }
        expect(response.body).to include('true')
      end

      it 'updateアクションのリクエストが失敗すると、レスポンスにエラーメッセージが含まれる' do
        patch user_subscription_path(@user, @subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: -1)
        }
        expect(response.body).to include('価格は0以上の整数を入力してください')
      end
    end
  end

  describe 'PATCH #update(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'updateアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription)
        patch user_subscription_path(user, subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: 123_45)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription)
        patch user_subscription_path(user, subs), params: {
          subscription: FactoryBot.attributes_for(:subscription, price: 123_45)
        }
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'DELETE #destroy(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが削除される' do
      it 'destroyアクションのリクエストが成功すると、HTTPステータス200が返ってくる' do
        delete user_subscription_path(@user, @subs)
        expect(response.status).to eq(200)
      end

      it 'destroyアクションのリクエストが成功すると、レスポンスでサブスク名が返る' do
        delete user_subscription_path(@user, @subs)
        expect(response.body).to include(@subs.name)
      end

      it 'destroyアクションのリクエストが成功すると、サブスクレコードのカウントが減少する' do
        expect(Subscription.all.length).to eq(1)
        expect { delete user_subscription_path(@user, @subs) }.to change { Subscription.count }.by(-1)
      end

      it 'destroyアクションのリクエストが成功すると、紐づく契約更新レコードのカウントが減少する' do
        expect(ContractCancel.all.length).to eq(1)
        expect { delete user_subscription_path(@user, @subs) }.to change { ContractRenewal.count }.by(-1)
      end

      it 'destroyアクションのリクエストが成功すると、紐づく契約解約レコードのカウントが減少する' do
        expect(ContractCancel.all.length).to eq(1)
        expect { delete user_subscription_path(@user, @subs) }.to change { ContractCancel.count }.by(-1)
      end

      it 'destroyアクションのリクエストが成功すると、紐づく契約更新レコードのカウントが減少する' do
        expect(Review.all.length).to eq(1)
        expect { delete user_subscription_path(@user, @subs) }.to change { Review.count }.by(-1)
      end

      it 'destroyアクションのリクエストが成功すると、紐づく契約更新レコードのカウントが減少する' do
        expect(ActionPlan.all.length).to eq(1)
        expect { delete user_subscription_path(@user, @subs) }.to change { ActionPlan.count }.by(-1)
      end
    end

    context '存在しないサブスクidでdestroyアクションにリクエストすると、マイページにリダイレクトする' do
      it 'destroyアクションにリクエストすると、HTTPステータス302が返ってくる' do
        delete user_subscription_path(@user, @subs.id + 1)
        expect(response.status).to eq(302)
      end

      it 'destroyアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        delete user_subscription_path(@user, @subs.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでdestroyアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'destroyアクションにリクエストを送ると、HTTPステータス302が返る' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        delete user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'destroyアクションにリクエストを送ると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        delete user_subscription_path(user, subs)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'DELETE #destroy(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'destroyアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription)
        delete user_subscription_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'destroyアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription)
        delete user_subscription_path(user, subs)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end
end
