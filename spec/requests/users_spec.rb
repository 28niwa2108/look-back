require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #show(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、マイページが表示される' do
      it 'showアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get user_path(@user)
        expect(response.status).to eq(200)
      end

      it 'showアクションにリクエストすると、レスポンスに登録済のサブスク名が存在する' do
        get user_path(@user)
        expect(response.body).to include(@subs.name)
      end

      it 'showアクションにリクエストすると、レスポンスに解約済のサブスク名は存在しない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        cancel = FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        get user_path(@user)
        expect(response.body).not_to include(cancel.subscription.name)
      end

      it 'showアクションにリクエストすると、レスポンスに次回更新日が存在する' do
        get user_path(@user)
        next_update_date = @renewal.next_update_date
        year = next_update_date.year
        month = next_update_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = next_update_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day}")
      end
    end

    context '他人のマイページに遷移しようとすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get user_path(user)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get user_path(user)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #show(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'showアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get user_path(user)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get user_path(user)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #edit(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      sign_in(@user)
    end

    context 'ログイン状態なら、退会確認画面が表示される' do
      it 'editアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get edit_user_path(@user)
        expect(response.status).to eq(200)
      end

      it 'editアクションにリクエストすると、退会処理の文字が存在する' do
        get edit_user_path(@user)
        expect(response.body).to include('退会処理')
      end

      it 'editアクションにリクエストすると、退会説明が存在する' do
        get edit_user_path(@user)
        expect(response.body).to include('登録したサブスクデータも全て削除されます')
      end

      it 'editアクションにリクエストすると、退会しますボタンが存在する' do
        get edit_user_path(@user)
        expect(response.body).to include('退会します')
      end
    end

    context '他人退会処理ページに遷移しようとすると、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get edit_user_path(user)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get edit_user_path(user)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #edit(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'editアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get edit_user_path(user)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        get edit_user_path(user)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end



  describe 'GET #thanks(退会後ログアウト状態)' do
    context 'thanksアクションにリクエストを送ると、退会完了画面が表示される' do
      it 'thanksアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get thanks_users_path
        expect(response.status).to eq(200)
      end

      it 'thanksアクションにリクエストすると、退会完了の文字が存在する' do
        get thanks_users_path
        expect(response.body).to include('退会完了')
      end

      it 'thanksアクションにリクエストすると、退会完了メッセージが存在する' do
        get thanks_users_path
        expect(response.body).to include('ユーザー情報を削除しました')
      end

      it 'thanksアクションにリクエストすると、アンケートリンクが存在する' do
        get thanks_users_path
        expect(response.body).to include('アンケート')
      end
    end
  end

  describe 'GET #thanks(ログイン状態)' do
    context 'ログイン状態では、マイページにリダイレクトする' do
      it 'thanksアクションにリクエストすると、HTTPステータス302が返ってくる' do
        @user = FactoryBot.create(:user)
        sign_in(@user)
        get thanks_users_path
        expect(response.status).to eq(302)
      end

      it 'thanksアクションにリクエストすると、レスポンスにマイページのURLが含まれる' do
        @user = FactoryBot.create(:user)
        sign_in(@user)
        get thanks_users_path
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end
end
