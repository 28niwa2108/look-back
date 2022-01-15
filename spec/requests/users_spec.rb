require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @subs = FactoryBot.create(:subscription, user_id: @user.id)
    @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
    sign_in(@user)
  end

  describe 'GET #show' do
    context 'ログイン状態なら、マイページが表示される' do
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get user_path(@user)
        expect(response.status).to eq(200)
      end

      it 'レスポンスに登録済のサブスク名が存在する' do
        get user_path(@user)
        expect(response.body).to include(@subs.name)
      end

      it 'レスポンスに次回更新日が存在する' do
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

    context 'ログイン失敗すると、トップページにリダイレクトする' do
      it 'showアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get user_path(user)
        expect(response.status).to eq(302)
      end
    end
  end
end
