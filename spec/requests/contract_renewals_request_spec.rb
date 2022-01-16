require 'rails_helper'

RSpec.describe 'ContractRenewals', type: :request do

  describe 'PATCH #update(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが更新される' do
      it 'updateアクションのリクエストが成功すると、HTTPステータス200が返ってくる' do
        patch user_subscription_contract_renewal_path(@user, @subs, @renewal)
        expect(response.status).to eq(200)
      end

      it 'updateアクションのリクエストが成功すると、サブスクレコードの値が更新される' do
        expect {
          patch user_subscription_contract_renewal_path(@user, @subs, @renewal)
        }.to change{ 
          ContractRenewal.find(@renewal.id).renewal_count
        }.from(@renewal.renewal_count).to(@renewal.renewal_count + 1)
      end

      it 'updateアクションのリクエストが成功すると、レスポンスでprocess_ngはfalseで返る' do
        patch user_subscription_contract_renewal_path(@user, @subs, @renewal)
        expect(response.body).to include("{\"process_ng\":false}")
      end

      it 'updateアクションのリクエストが成功すると、レスポンスにサブスク名が含まれる' do
        patch user_subscription_contract_renewal_path(@user, @subs, @renewal)
        expect(response.body).to include(@subs.name)
      end

      it 'updateアクションのリクエストが成功すると、レスポンスにレビュー編集画面へのURLが含まれる' do
        patch user_subscription_contract_renewal_path(@user, @subs, @renewal)
        expect(Review.all.length).to eq(1)
        review = Review.find_by(user_id: @user.id)
        expect(response.body).to include("/users/#{@user.id}/subscriptions/#{@subs.id}/reviews/"{review.id}/edit")
      end






    end

    context '他人のidでupdateアクションにリクエストを送る場合、マイページにリダイレクトする' do
      # it 'updateアクションにリクエストを送ると、HTTPステータス302が返る' do
      #   user = FactoryBot.create(:user)
      #   subs = FactoryBot.create(:subscription)
      #   patch user_subscription_path(user, subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price:12345)
      #   }
      #   expect(response.status).to eq(302)
      # end

      # it 'updateアクションにリクエストを送ると、レスポンスにマイページのURLを含む' do
      #   user = FactoryBot.create(:user)
      #   subs = FactoryBot.create(:subscription)
      #   patch user_subscription_path(user, subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price:12345)
      #   }
      #   expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      # end
    end

    context 'サブスク更新が失敗する場合' do
      # it 'updateアクションのリクエストが失敗すると、HTTPステータスは200が返る' do
      #   patch user_subscription_path(@user, @subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price: -1)
      #   }
      #   expect(response.status).to eq(200)
      # end

      # it 'updateアクションのリクエストが失敗すると、サブスクレコードの値は更新されない' do
      #   expect {
      #     patch user_subscription_path(@user, @subs), params: {
      #       subscription: FactoryBot.attributes_for(:subscription, price: -1)
      #     }
      #   }.to_not change{ Subscription.find(@subs.id).price }
      # end

      # it 'updateアクションのリクエストが失敗すると、レスポンスでprocess_ngはtrueで返る' do
      #   patch user_subscription_path(@user, @subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price: -1)
      #   }
      #   expect(response.body).to include("\"process_ng\":true")
      # end

      # it 'updateアクションのリクエストが失敗すると、レスポンスにエラーメッセージが含まれる' do
      #   patch user_subscription_path(@user, @subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price: -1)
      #   }
      #   expect(response.body).to include('価格は0以上の整数を入力してください')
      # end
    end
  end

  describe 'PATCH #update(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      # it 'updateアクションにリクエストするとHTTPステータス302が返ってくる' do
      #   user = FactoryBot.create(:user)
      #   subs = FactoryBot.create(:subscription)
      #   patch user_subscription_path(user, subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price: 12345)
      #   }
      #   expect(response.status).to eq(302)
      # end

      # it 'updateアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
      #   user = FactoryBot.create(:user)
      #   subs = FactoryBot.create(:subscription)
      #   patch user_subscription_path(user, subs), params: {
      #     subscription: FactoryBot.attributes_for(:subscription, price: 12345)
      #   }
      #   expect(response.body).to include("http://www.example.com/users/sign_in")
      # end
    end
  end
end
