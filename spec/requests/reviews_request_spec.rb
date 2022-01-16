require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  describe 'GET #all_index(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、未評価レビュー 一覧ページが表示される' do
      it 'all_indexアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get all_index_user_reviews_path(@user)
        expect(response.status).to eq(200)
      end

      it 'all_indexアクションにリクエストすると、レスポンスに振り返り待ちの文字が存在する' do
        get all_index_user_reviews_path(@user)
        expect(response.body).to include('振り返り待ち')
      end

      it 'all_indexアクションにリクエストすると、レスポンスに未評価のサブスク名が存在する' do
        get all_index_user_reviews_path(@user)
        expect(response.body).to include(@review.subscription.name)
      end

      it 'all_indexアクションにリクエストすると、レスポンスに全レビュー評価済のサブスク名は存在しない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: subs.id, later_check_id: 1)
        get all_index_user_reviews_path(@user)
        expect(response.body).not_to include(review.subscription.name)
      end

      it 'all_indexアクションにリクエストすると、対象評価期間(開始)が存在する' do
        get all_index_user_reviews_path(@user)
        start_date = @review.start_date
        year = start_date.year
        month = start_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = start_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day} ~")
      end

      it 'all_indexアクションにリクエストすると、対象評価期間(終了)が存在する' do
        get all_index_user_reviews_path(@user)
        end_date = @review.end_date
        year = end_date.year
        month = end_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = end_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("~ #{year}-#{month}-#{day}")
      end
    end

    context '他人のidでall_indexアクションにリクエストすると、マイページにリダイレクトする' do
      it 'all_indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get all_index_user_reviews_path(user)
        expect(response.status).to eq(302)
      end

      it 'all_indexアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        get all_index_user_reviews_path(user)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #all_index(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'all_indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        get all_index_user_reviews_path(user)
        expect(response.status).to eq(302)
      end

      it 'all_indexアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        get all_index_user_reviews_path(user)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end
end
# そんざいしないサブ数idで
