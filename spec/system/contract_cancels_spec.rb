require 'rails_helper'

RSpec.describe 'ContractCancels', type: :system do
  describe 'サブスク解約' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
      @cancel = FactoryBot.build(:contract_cancel, subscription_id: @subs.id)
    end

    context 'サブスク解約ができるとき' do
      it 'ログイン状態なら、サブスク解約ができ、その後マイページに遷移する' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find_link('解約', href: new_user_subscription_contract_cancel_path(@user, @subs)).click
        expect(current_path).to eq(new_user_subscription_contract_cancel_path(@user, @subs))
        expect(page).to have_content("#{@subs.name}の解約")
        fill_in 'contract_cancel_cancel_date', with: Date.today
        select '価格が高い', from: 'readon_id'
        fill_in 'action_comment', with: '◯◯で××なので解約する'
        expect { click_button '解約する' }.to change { ContractCancel.count }.by(1)
        expect(current_path).to eq(user_path(@user))
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(@subs.name)
      end
    end

    context 'サブスク解約ができないとき' do
      it '必要な情報が選択されていないと、サブスク解約ができず、レンダーで解約ページに戻る' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find_link('解約', href: new_user_subscription_contract_cancel_path(@user, @subs)).click
        expect(current_path).to eq(new_user_subscription_contract_cancel_path(@user, @subs))
        expect(page).to have_content("#{@subs.name}の解約")
        fill_in 'contract_cancel_cancel_date', with: ''
        expect { click_button '解約する' }.to change { ContractCancel.count }.by(0)
        expect(current_path).to eq(user_subscription_contract_cancels_path(@user, @subs))
        expect(page).to have_content('解約日を入力してください')
        expect(page).to have_content('解約理由を選択してください')
      end

      it '解約済のサブスクは、サブスク一覧に表示されず、解約できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_no_content(subs.name)
      end

      it 'ログアウト状態では、サブスク解約ページに遷移できず、ログインページに遷移する' do
        visit new_user_subscription_contract_cancel_path(@user, @subs)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク解約一覧表示' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @cancel = FactoryBot.create(:contract_cancel, subscription_id: @subs.id)
    end

    context '解約サブスク一覧を確認できるとき' do
      it 'ログイン状態なら、解約サブスク一覧を確認できる' do
        sign_in_support(@user)
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(@subs.name)
      end
    end

    context '解約サブスク一覧を確認できないとき' do
      it '未解約のサブスクは、解約一覧では確認できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        sign_in_support(@user)
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(@subs.name)
        expect(page).to have_no_content(subs.name)
      end

      it 'ログアウト状態では、解約一覧ページに遷移できず、ログインページに遷移する' do
        visit user_contract_cancels_path(@user)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end
end
