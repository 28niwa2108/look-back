require 'rails_helper'

RSpec.describe 'ContractRenewals', type: :system do
  describe 'サブスク更新' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id, next_update_date: Date.today)
    end

    context 'サブスク更新ができるとき' do
      it 'ログイン状態なら、サブスク更新日以降にサブスク更新ができ、振り返りページに遷移する' do
        sign_in_support(@user)
        expect(find('.m-sub-update-link_tag').value).to eq('Clickで更新')
        expect(page).to have_no_content('次回更新日')
        expect(page).to have_no_selector('.update-notification')
        expect { find('.m-sub-update-link_tag').click }.to change { ContractRenewal.count }.by(0)
        expect(page).to have_content('更新完了')
        expect(page).to have_content("サブスク名：#{@subs.name}")
        expect(page).to have_content('続けて、振り返りをしましょう')
        expect(page).to have_content('...あとで振り返る')
        click_button 'Go'
        review = Review.find_by(subscription_id: @subs.id)
        expect(current_path).to eq(edit_user_subscription_review_path(@user, @subs, review))
        expect(page).to have_content("#{@subs.name}の振り返り")
      end

      it 'ログイン状態でサブスク更新後、後で振り返るを選択すると、マイページに戻る' do
        sign_in_support(@user)
        expect(find('.m-sub-update-link_tag').value).to eq('Clickで更新')
        expect(page).to have_no_selector('.update-notification')
        expect(page).to have_no_content('次回更新日')
        expect { find('.m-sub-update-link_tag').click }.to change { ContractRenewal.count }.by(0)
        expect(page).to have_content('更新完了')
        expect(page).to have_content("サブスク名：#{@subs.name}")
        expect(page).to have_content('続けて、振り返りをしましょう')
        expect(page).to have_content('...あとで振り返る')
        find('.swal2-footer').click
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content('次回更新日')
        expect(page).to have_selector('.update-notification', visible: false)
        find_link('Reviews', href: all_index_user_reviews_path(@user)).click
        expect(current_path).to eq(all_index_user_reviews_path(@user))
        expect(page).to have_content(@subs.name)
      end
    end
  end

  describe 'サブスク更新(失敗)' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id, next_update_date: Date.today + 10)
    end

    context 'サブスク更新ができないとき' do
      it 'サブスク更新日より前では、更新ボタンが表示されず、更新できない' do
        sign_in_support(@user)
        expect(page).to have_content('次回更新日')
        expect(page).to have_no_selector('.m-sub-update-link_tag')
        expect(page).to have_selector('.update-notification', visible: false)
      end

      it '解約済のサブスクは、サブスク一覧に表示されず、更新ができない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        expect(page).to have_no_content(subs.name)
      end
    end
  end
end
