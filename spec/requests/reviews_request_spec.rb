require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  describe 'GET #all_index(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
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

  describe 'GET #index(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 1)
      @action = FactoryBot.create(:action_plan, review_id: @review.id, action_plan: "#{'a' * 25}bb#{'c' * 10}")
      sign_in(@user)
    end

    context 'ログイン状態なら、レビュー 一覧ページが表示される' do
      it 'indexアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get user_subscription_reviews_path(@user, @subs)
        expect(response.status).to eq(200)
      end

      it 'indexアクションにリクエストすると、レスポンスにサブスク名が存在する' do
        get user_subscription_reviews_path(@user, @subs)
        expect(response.body).to include(@subs.name)
      end

      it 'indexアクションにリクエストすると、レスポンスにAction Planの文字が存在する' do
        get user_subscription_reviews_path(@user, @subs)
        expect(response.body).to include('Action Plan')
      end

      it 'indexアクションにリクエストすると、各レビューの対象評価期間(開始)が存在する' do
        get user_subscription_reviews_path(@user, @subs)
        start_date = @review.start_date
        year = start_date.year
        month = start_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = start_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day} ~")
      end

      it 'indexアクションにリクエストすると、対象評価期間(終了)が存在する' do
        get user_subscription_reviews_path(@user, @subs)
        end_date = @review.end_date
        year = end_date.year
        month = end_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = end_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("~ #{year}-#{month}-#{day}")
      end

      it 'indexアクションにリクエストすると、評価済のレビューでは、アクションプランが「...」を含め30文字表示される' do
        get user_subscription_reviews_path(@user, @subs)
        action_plan = "#{@action.action_plan[0, 27]}..."
        expect(response.body).to include(action_plan)
      end

      it '上記において、アクションプランが丁度30文字の場合は、全表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 1)
        action = FactoryBot.create(:action_plan, review_id: review.id, action_plan: "#{'a' * 29}b")
        get user_subscription_reviews_path(@user, @subs)
        expect(response.body).to include(action.action_plan)
      end
    end

    context '存在しないサブスクidでindexアクションにリクエストすると、マイページにリダイレクトする' do
      it 'indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get user_subscription_reviews_path(@user, @subs.id + 1)
        expect(response.status).to eq(302)
      end

      it 'indexアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get user_subscription_reviews_path(@user, @subs.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでindexアクションにリクエストすると、マイページにリダイレクトする' do
      it 'indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_reviews_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'indexアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_reviews_path(user, subs)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #index(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'indexアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_reviews_path(user, subs)
        expect(response.status).to eq(302)
      end

      it 'indexアクションにリクエストすると、レスポンスにログインページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        get user_subscription_reviews_path(user, subs)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #show(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 1)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、レビュー 一覧ページが表示される' do
      it 'showアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.status).to eq(200)
      end

      it 'showアクションにリクエストすると、レスポンスにサブスク名が存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@subs.name)
      end

      it 'showアクションにリクエストすると、レスポンスにEditボタンが存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('edit')
      end

      it 'showアクションにリクエストすると、レスポンスにAction Planの文字が存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('Action Plan')
      end

      it 'showアクションにリクエストすると、レスポンスにSubscriptionの文字が存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('Subscription')
      end

      it 'showアクションにリクエストすると、各レビューの対象評価期間(開始)が存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        start_date = @review.start_date
        year = start_date.year
        month = start_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = start_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day} ~")
      end

      it 'showアクションにリクエストすると、対象評価期間(終了)が存在する' do
        get user_subscription_review_path(@user, @subs, @review)
        end_date = @review.end_date
        year = end_date.year
        month = end_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = end_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("~ #{year}-#{month}-#{day}")
      end

      it 'showアクションにリクエストすると、アクションプランを入力済なら、アクションプランが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_plan)
      end

      it 'showアクションにリクエストすると、アクションプランが未記入なら、未記入〜の文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_plan: '')
        get user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include('アクションプランが未入力です')
      end

      it 'showアクションにリクエストすると、アクションレビューコメントが入力されていたら、アクションレビューコメントが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_review_comment)
      end

      it 'showアクションにリクエストすると、アクションレビューコメントが未記入なら、未記入〜の文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_review_comment: '')
        get user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include('行動の振り返りが未入力です')
      end

      it 'showアクションにリクエストすると、サブスクレビューが入力されていたら、サブスクレビューが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@review.review_comment)
      end

      it 'showアクションにリクエストすると、サブスクレビューが未記入なら、未記入〜の文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2, review_comment: '')
        FactoryBot.create(:action_plan, review_id: review.id)
        get user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include('レビューが未入力です')
      end

      it 'showアクションにリクエストすると、アクションプラン評価設定済なら、レスポンスに☆数が含まれる' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_rate.to_s)
      end

      it 'showアクションにリクエストすると、サブスク評価設定済なら、レスポンスに☆数が含まれる' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@review.review_rate.to_s)
      end
    end

    context '他人のidでshowアクションにリクエストすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        get user_subscription_review_path(user, subs, review)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        get user_subscription_review_path(user, subs, review)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '存在しないサブスクidでshowアクションにリクエストすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get user_subscription_review_path(@user, @subs.id + 1, @review)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get user_subscription_review_path(@user, @subs.id + 1, @review)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '存在しないレビューidでshowアクションにリクエストすると、マイページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get user_subscription_review_path(@user, @subs, @review.id + 1)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get user_subscription_review_path(@user, @subs, @review.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #show(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'showアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        get user_subscription_review_path(user, subs, review)
        expect(response.status).to eq(302)
      end

      it 'showアクションにリクエストすると、レスポンスにログインページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        get user_subscription_review_path(user, subs, review)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'GET #edit(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 1)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスク編集ページが表示される' do
      it 'editアクションにリクエストすると、正常にレスポンスが返ってくる' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.status).to eq(200)
      end

      it 'editアクションにリクエストすると、レスポンスにサブスク名の振り返り文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include("#{@subs.name}の振り返り")
      end

      it 'showアクションにリクエストすると、レビューの対象評価期間(開始)が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        start_date = @review.start_date
        year = start_date.year
        month = start_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = start_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day} 〜")
      end

      it 'showアクションにリクエストすると、レビューの対象評価期間(終了)が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        end_date = @review.end_date
        year = end_date.year
        month = end_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = end_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("〜 #{year}-#{month}-#{day}")
      end

      it 'editアクションにリクエストすると、レスポンスにあとで振り返るの文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('あとで振り返る')
      end

      it 'editアクションにリクエストすると、サブスクは☆いくつ？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('サブスクは☆いくつ？')
      end

      it 'editアクションにリクエストすると、活用度は☆いくつ？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('活用度は☆いくつ？')
      end

      it 'editアクションにリクエストすると、今回は何を実践する？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('今回は何を実践する？')
      end

      it 'editアクションにリクエストすると、あと300文字の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('あと', '300', '文字')
      end

      it 'editアクションにリクエストすると、レビューボタンの文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('レビュー')
      end

      it 'editアクションにリクエストすると、アクションプランを入力済なら、アクションプランの文字が含まれる' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_plan)
      end

      it 'editアクションにリクエストすると、アクションプランが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_plan: '')
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include('次回更新日までのアクションプランを設定しましょう！')
      end

      it 'editアクションにリクエストすると、アクションレビューコメントが入力されていたら、アクションレビューコメントが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_review_comment)
      end

      it 'editアクションにリクエストすると、アクションレビューコメントが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_review_comment: '')
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include("実践したアクションプランを振り返ってみましょう！\n何に活用できたか、どんな行動ができたか、思い出してみましょう。")
      end

      it 'editアクションにリクエストすると、サブスクレビューが入力されていたら、サブスクレビューが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        get edit_user_subscription_review_path(@user, @subs, @review)
      end

      it 'editアクションにリクエストすると、サブスクレビューが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2, review_comment: '')
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include("今回のサブスクコンテンツは、いかがでしたか？\n感じたことを書き出して見ましょう！")
      end
    end

    context '存在しないサブスクidでeditアクションにリクエストすると、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get edit_user_subscription_review_path(@user, @subs.id + 1, @review)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get edit_user_subscription_review_path(@user, @subs.id + 1, @review)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '存在しないレビューidでeditアクションにリクエストすると、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        get edit_user_subscription_review_path(@user, @subs, @review.id + 1)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        get edit_user_subscription_review_path(@user, @subs, @review.id + 1)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '他人のidでeditアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id)
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(user, subs, review)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id)
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(user, subs, review)
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end
  end

  describe 'GET #edit(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'editアクションにリクエストすると、HTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id)
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(user, subs, review)
        expect(response.status).to eq(302)
      end

      it 'editアクションにリクエストすると、レスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id)
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(user, subs, review)
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end

  describe 'PATCH #update(ログイン状態)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 1)
      @action = FactoryBot.create(:action_plan, review_id: @review.id)
      sign_in(@user)
    end

    context 'ログイン状態なら、サブスクが更新される' do
      it 'updateアクションのリクエストが成功すると、HTTPステータス302が返ってくる' do
        patch user_subscription_review_path(@user, @subs, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションのリクエストが成功すると、レビューレコードの値が更新される' do
        expect {
          patch user_subscription_review_path(@user, @subs, @review), params: {
            review_action: FactoryBot.attributes_for(:review_action, review_comment: 'コメントを更新しました')
          }
        }.to change { Review.find(@review.id).review_comment }.from(@review.review_comment).to('コメントを更新しました')
      end

      it 'updateアクションのリクエストが成功すると、レスポンスにサブスクの評価一覧ページのURLを含む' do
        patch user_subscription_review_path(@user, @subs, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.body).to include("/users/#{@user.id}/subscriptions/#{@subs.id}/reviews")
      end
    end

    context '他人のidでupdateアクションにリクエストを送る場合、マイページにリダイレクトする' do
      it 'updateアクションにリクエストを送ると、HTTPステータス302が返る' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        FactoryBot.create(:action_plan, review_id: review.id)
        patch user_subscription_review_path(user, subs, review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストを送ると、レスポンスにマイページのURLを含む' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        patch user_subscription_review_path(user, subs, review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '存在しないサブスクidでupdateアクションにリクエストすると、マイページにリダイレクトする' do
      it 'updateアクションにリクエストすると、HTTPステータス302が返ってくる' do
        patch user_subscription_review_path(@user, @subs.id + 1, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        patch user_subscription_review_path(@user, @subs.id + 1, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context '存在しないレビューidでupdateアクションにリクエストすると、マイページにリダイレクトする' do
      it 'updateアクションにリクエストすると、HTTPステータス302が返ってくる' do
        patch user_subscription_review_path(@user, @subs, @review.id + 1), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストすると、レスポンスにマイページのURLを含む' do
        patch user_subscription_review_path(@user, @subs, @review.id + 1), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.body).to include("http://www.example.com/users/#{@user.id}")
      end
    end

    context 'サブスク更新が失敗する場合' do
      it 'updateアクションのリクエストが失敗すると、HTTPステータスは200が返る' do
        patch user_subscription_review_path(@user, @subs, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action, action_plan: '', later_check_id: 1)
        }
        expect(response.status).to eq(200)
      end

      it 'updateアクションのリクエストが失敗すると、レビューレコードの値は更新されない' do
        expect {
          patch user_subscription_review_path(@user, @subs, @review), params: {
            review_action: FactoryBot.attributes_for(:review_action, review_rate: '', later_check_id: 1)
          }
        }.to_not change { Review.find(@review.id).review_rate }.from(@review.review_rate)
      end

      it 'updateアクションのリクエストが失敗すると、アクションプランレコードの値は更新されない' do
        expect {
          patch user_subscription_review_path(@user, @subs, @review), params: {
            review_action: FactoryBot.attributes_for(:review_action, action_plan: '', later_check_id: 1)
          }
        }.to_not change { ActionPlan.find(@action.id).action_plan }.from(@action.action_plan)
      end

      it 'updateアクションのリクエストが失敗すると、レスポンスにエラーメッセージが含まれる' do
        patch user_subscription_review_path(@user, @subs, @review), params: {
          review_action: FactoryBot.attributes_for(:review_action, action_plan: '', later_check_id: 1)
        }
        expect(response.body).to include('アクションプランを入力してください')
      end

      it 'editアクションにリクエストすると、レスポンスにサブスク名の振り返り文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include("#{@subs.name}の振り返り")
      end

      it 'showアクションにリクエストすると、レビューの対象評価期間(開始)が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        start_date = @review.start_date
        year = start_date.year
        month = start_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = start_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("#{year}-#{month}-#{day} 〜")
      end

      it 'showアクションにリクエストすると、レビューの対象評価期間(終了)が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        end_date = @review.end_date
        year = end_date.year
        month = end_date.month
        month = "0#{month}" if month.to_s.length == 1
        day = end_date.day
        day = "0#{day}" if day.to_s.length == 1
        expect(response.body).to include("〜 #{year}-#{month}-#{day}")
      end

      it 'editアクションにリクエストすると、レスポンスにあとで振り返るの文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('あとで振り返る')
      end

      it 'editアクションにリクエストすると、サブスクは☆いくつ？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('サブスクは☆いくつ？')
      end

      it 'editアクションにリクエストすると、活用度は☆いくつ？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('活用度は☆いくつ？')
      end

      it 'editアクションにリクエストすると、今回は何を実践する？の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('今回は何を実践する？')
      end

      it 'editアクションにリクエストすると、あと300文字の文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('あと', '300', '文字')
      end

      it 'editアクションにリクエストすると、レビューボタンの文字が存在する' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include('レビュー')
      end

      it 'editアクションにリクエストすると、アクションプランを入力済なら、アクションプランの文字が含まれる' do
        get edit_user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_plan)
      end

      it 'editアクションにリクエストすると、アクションプランが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_plan: '')
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include('次回更新日までのアクションプランを設定しましょう！')
      end

      it 'editアクションにリクエストすると、アクションレビューコメントが入力されていたら、アクションレビューコメントが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        expect(response.body).to include(@action.action_review_comment)
      end

      it 'editアクションにリクエストすると、アクションレビューコメントが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2)
        FactoryBot.create(:action_plan, review_id: review.id, action_review_comment: '')
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include("実践したアクションプランを振り返ってみましょう！\n何に活用できたか、どんな行動ができたか、思い出してみましょう。")
      end

      it 'editアクションにリクエストすると、サブスクレビューが入力されていたら、サブスクレビューが表示される' do
        get user_subscription_review_path(@user, @subs, @review)
        get edit_user_subscription_review_path(@user, @subs, @review)
      end

      it 'editアクションにリクエストすると、サブスクレビューが未記入なら、placeholderの文字が表示される' do
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: @subs.id, later_check_id: 2, review_comment: '')
        FactoryBot.create(:action_plan, review_id: review.id)
        get edit_user_subscription_review_path(@user, @subs, review)
        expect(response.body).to include("今回のサブスクコンテンツは、いかがでしたか？\n感じたことを書き出して見ましょう！")
      end
    end
  end

  describe 'PATCH #update(ログアウト状態)' do
    context 'ログイン状態でない場合、ログインページにリダイレクトする' do
      it 'updateアクションにリクエストするとHTTPステータス302が返ってくる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        FactoryBot.create(:action_plan, review_id: review.id)
        patch user_subscription_review_path(user, subs, review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.status).to eq(302)
      end

      it 'updateアクションにリクエストするとレスポンスにサインインページのURLが含まれる' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        review = FactoryBot.create(:review, user_id: user.id, subscription_id: subs.id, later_check_id: 1)
        FactoryBot.create(:action_plan, review_id: review.id)
        patch user_subscription_review_path(user, subs, review), params: {
          review_action: FactoryBot.attributes_for(:review_action)
        }
        expect(response.body).to include('http://www.example.com/users/sign_in')
      end
    end
  end
end
