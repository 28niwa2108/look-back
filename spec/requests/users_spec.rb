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
        expect(response.body).to include("http://www.example.com/users/sign_in")
      end
    end
  end
end
