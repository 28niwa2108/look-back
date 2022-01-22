require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  describe 'サブスク評価' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(
        :review,
        user_id: @user.id,
        subscription_id: @subs.id,
        later_check_id: 2,
        review_rate: nil,
        review_comment: ''
      )
      @action = FactoryBot.create(
        :action_plan,
        review_id: @review.id,
        action_rate: nil,
        action_review_comment: '',
        action_plan: ''
      )
    end

    context 'サブスク評価ができるとき' do
      it '正しい情報を入力すればサブスク評価ができ、サブスク評価一覧ページに移動する' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('#review_rate').find('img[alt="1"]').click
        fill_in 'review_comment', with: 'レビューコメントの入力'
        find('#action_rate').find('img[alt="5"]').click
        fill_in 'action_comment', with: 'アクションコメントの入力'
        fill_in 'action_plan', with: 'アクションプランの入力'
        before = @review.review_rate
        expect { find('input[type="submit"]').click }.to change { Review.find(@review.id).review_rate }.from(before).to(1)
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content('アクションプランの入力')
      end

      it '評価詳細のEditからもサブスク評価ができ、サブスク評価一覧ページに移動する' do
        sign_in_support(@user)
        visit user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content('Edit')
        click_button 'Edit'
        expect(page).to have_content("#{@subs.name}の振り返り")
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        find('#review_rate').find('img[alt="1"]').click
        fill_in 'review_comment', with: 'レビューコメントの入力'
        find('#action_rate').find('img[alt="5"]').click
        fill_in 'action_comment', with: 'アクションコメントの入力'
        fill_in 'action_plan', with: 'a' * 50
        before = @action.action_rate
        expect { find('input[type="submit"]').click }.to change { ActionPlan.find(@action.id).action_rate }.from(before).to(5)
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content("#{'a' * 27}...")
      end

      it '未評価レビュー 一覧からもサブスク評価ができ、サブスク評価一覧ページに移動する' do
        sign_in_support(@user)
        find_link('Reviews', href: all_index_user_reviews_path(@user)).click
        find_link('', href: edit_user_subscription_review_path(@user, @subs, @review)).click
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('#review_rate').find('img[alt="1"]').click
        fill_in 'review_comment', with: 'レビュー'
        find('#action_rate').find('img[alt="5"]').click
        fill_in 'action_comment', with: 'コメントの入力'
        fill_in 'action_plan', with: 'アクションプランの入力'
        before = @review.review_comment
        expect { find('input[type="submit"]').click }.to change { Review.find(@review.id).review_comment }.from(before).to('レビュー')
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        visit all_index_user_reviews_path(@user)
        expect(page).to have_no_content(@subs.name)
      end
    end

    context 'サブスク評価ができないとき' do
      it '誤った情報では評価ができず、レンダーで評価ページが表示される' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        expect { find('input[type="submit"]').click }.not_to change { Review.find(@review.id).review_rate }.from(nil)
        expect(current_path).to eq(user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        expect(page).to have_content('サブスク☆レビューを選択してください')
        expect(page).to have_content('アクションプラン☆レビューを選択してください')
        expect(page).to have_content('アクションプランを入力してください')
      end

      it '後で評価するを選択すると、評価の入力ができなくなる' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('.dot').click
        expect(page).to have_content('入力内容は、一時保存されます')
        expect(page).to have_no_selector('#review_rate')
        expect(page).to have_no_selector('#review_comment')
        expect(page).to have_no_selector('#action_rate')
        expect(page).to have_no_selector('#action_comment')
        expect(page).to have_no_selector('#action_plan')
      end

      it 'ログアウト状態では、サブスク評価ページに遷移できず、ログインページに遷移する' do
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク評価・一時保存機能' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(
        :review,
        user_id: @user.id,
        subscription_id: @subs.id,
        later_check_id: 2,
        review_rate: nil,
        review_comment: ''
      )
      @action = FactoryBot.create(
        :action_plan,
        review_id: @review.id,
        action_rate: nil,
        action_review_comment: '',
        action_plan: ''
      )
    end

    context '一時保存できるとき' do
      it 'サブスク更新後のホップアップで、あとで振り返るを選択すると、未評価状態のレビューが保存される' do
        user = FactoryBot.create(:user)
        subs = FactoryBot.create(:subscription, user_id: user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id, next_update_date: Date.today)
        sign_in_support(user)
        expect(find('.m-sub-update-link_tag').value).to eq('Clickで更新')
        expect { find('.m-sub-update-link_tag').click }.to change { ContractRenewal.count }.by(0)
        expect(page).to have_content('更新完了')
        expect(page).to have_content("サブスク名：#{subs.name}")
        expect(page).to have_content('続けて、振り返りをしましょう')
        expect(page).to have_content('...あとで振り返る')
        find('.swal2-footer').click
        review = Review.find_by(subscription_id: subs.id)
        expect(review.review_rate).to eq(nil)
        expect(ActionPlan.find_by(review_id: review.id).action_rate).to eq(nil)
        visit all_index_user_reviews_path(user)
        expect(page).to have_content(subs.name)
      end

      it '何も入力せず、後で振り返るするを有効にすると、未評価状態のレビューが保存される' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('.dot').click
        find('input[type="submit"]').click
        expect(Review.find(@review.id).review_rate).to eq(nil)
        expect(ActionPlan.find(@action.id).action_rate).to eq(nil)
        visit all_index_user_reviews_path(@user)
        expect(page).to have_content(@subs.name)
      end

      it 'レビュー入力後、あとで振り返るを有効にすると、入力内容が一時保存された未評価状態のレビューが保存される' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('#review_rate').find('img[alt="1"]').click
        fill_in 'review_comment', with: 'レビューコメントの入力'
        fill_in 'action_plan', with: 'アクションプランの入力'
        find('.dot').click
        before = @review.review_rate
        expect { find('input[type="submit"]').click }.to change { Review.find(@review.id).review_rate }.from(before).to(1)
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content('アクションプランの入力')
        visit all_index_user_reviews_path(@user)
        expect(page).to have_content(@subs.name)
      end
    end

    context '一時保存できないとき' do
      it 'あとで振り返るを有効にしないと、一時保存できず、レンダーで評価ページに戻る' do
        sign_in_support(@user)
        visit edit_user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        find('#review_rate').find('img[alt="1"]').click
        fill_in 'review_comment', with: 'レビューコメントの入力'
        fill_in 'action_plan', with: 'アクションプランの入力'
        expect { find('input[type="submit"]').click }.not_to change { Review.find(@review.id).review_rate }.from(nil)
        expect(current_path).to eq(user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content("#{@subs.name}の振り返り")
        expect(page).to have_content('アクションプラン☆レビューを選択してください')
      end
    end
  end

  describe 'サブスク未評価一覧表示' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(
        :review,
        user_id: @user.id,
        subscription_id: @subs.id,
        later_check_id: 2,
        review_rate: nil,
        review_comment: ''
      )
      @action = FactoryBot.create(
        :action_plan,
        review_id: @review.id,
        action_rate: nil,
        action_review_comment: '',
        action_plan: ''
      )
    end

    context '未評価サブスク一覧を確認できるとき' do
      it 'ログイン状態で未評価のレビューが存在すれば、未評価サブスク一覧を確認できる' do
        sign_in_support(@user)
        find_link('Reviews', href: all_index_user_reviews_path(@user)).click
        expect(current_path).to eq(all_index_user_reviews_path(@user))
        expect(page).to have_content(@subs.name)
      end
    end

    context '未評価サブスク一覧を確認できないとき' do
      it '評価済のレビューしか存在しないサブスクは、未評価一覧では確認できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        review = FactoryBot.create(:review, user_id: @user.id, subscription_id: subs.id, later_check_id: 1)
        FactoryBot.create(:action_plan, review_id: review.id)
        sign_in_support(@user)
        expect(page).to have_content(subs.name)
        find_link('Reviews', href: all_index_user_reviews_path(@user)).click
        expect(current_path).to eq(all_index_user_reviews_path(@user))
        expect(page).to have_no_content(subs.name)
      end

      it 'まだ評価が存在しないサブスクは、未評価一覧では確認できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        sign_in_support(@user)
        expect(page).to have_content(subs.name)
        find_link('Reviews', href: all_index_user_reviews_path(@user)).click
        expect(current_path).to eq(all_index_user_reviews_path(@user))
        expect(page).to have_no_content(subs.name)
      end

      it 'ログアウト状態では、未評価一覧ページに遷移できず、ログインページに遷移する' do
        visit all_index_user_reviews_path(@user)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク評価一覧表示' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(
        :review,
        user_id: @user.id,
        subscription_id: @subs.id,
        later_check_id: 1
      )
      @action = FactoryBot.create(
        :action_plan,
        review_id: @review.id
      )
    end

    context 'サブスク評価一覧を確認できるとき' do
      it 'ログイン状態であれば、サブスク評価一覧を確認できる' do
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        find_link('もっと見る', href: user_subscription_reviews_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content(@subs.name)
        expect(page).to have_content('Action Plan')
        expect(page).to have_content(@action.action_plan)
      end
    end

    context 'サブスク評価一覧を確認できないとき' do
      it 'まだ評価が存在しないサブスクは、一覧では確認できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, subs)).click
        expect(current_path).to eq(user_subscription_path(@user, subs))
        find_link('もっと見る', href: user_subscription_reviews_path(@user, subs)).click
        expect(current_path).to eq(user_subscription_reviews_path(@user, subs))
        expect(page).to have_content(subs.name)
        expect(page).to have_no_content('Action Plan')
      end

      it 'ログアウト状態では、一覧ページに遷移できず、ログインページに遷移する' do
        visit user_subscription_reviews_path(@user, @subs)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク評価詳細表示' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @review = FactoryBot.create(
        :review,
        user_id: @user.id,
        subscription_id: @subs.id,
        later_check_id: 1
      )
      @action = FactoryBot.create(
        :action_plan,
        review_id: @review.id
      )
    end

    context 'サブスク評価詳細が確認できるとき' do
      it 'ログイン状態なら、サブスク詳細が確認できる' do
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        find_link('もっと見る', href: user_subscription_reviews_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content(@subs.name)
        expect(page).to have_content('Action Plan')
        expect(page).to have_content(@action.action_plan)
        find_link('Look More', href: user_subscription_review_path(@user, @subs, @review)).click
        expect(current_path).to eq(user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content(@review.review_comment)
        expect(page).to have_content(@action.action_review_comment)
        expect(page).to have_content('Edit')
      end

      it 'ログイン状態なら、解約済のサブスクも、過去のレビュー詳細を確認できる' do
        @cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
        sign_in_support(@user)
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(@subs.name)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        find_link('もっと見る', href: user_subscription_reviews_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_reviews_path(@user, @subs))
        expect(page).to have_content(@subs.name)
        expect(page).to have_content('Action Plan')
        expect(page).to have_content(@action.action_plan)
        find_link('Look More', href: user_subscription_review_path(@user, @subs, @review)).click
        expect(current_path).to eq(user_subscription_review_path(@user, @subs, @review))
        expect(page).to have_content(@review.review_comment)
        expect(page).to have_content(@action.action_review_comment)
        expect(page).to have_content('Edit')
      end
    end

    context 'サブスク詳細が確認できないとき' do
      it 'ログアウト状態では、サブスク詳細ページに遷移できず、ログインページに遷移する' do
        visit user_subscription_review_path(@user, @subs, @review)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end
end
