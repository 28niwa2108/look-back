require 'rails_helper'

RSpec.describe 'Subscriptions', type: :system do
  describe 'サブスク詳細' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
    end

    context 'サブスク詳細が確認できるとき' do
      it 'ログイン状態なら、サブスク詳細が確認できる' do
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        expect(page).to have_content('Price')
        expect(page).to have_content('Period')
        expect(page).to have_content('Review')
      end

      it 'ログイン状態なら、解約済のサブスク詳細も確認できる' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(subs.name)
        find_link('', href: user_subscription_path(@user, subs)).click
        expect(current_path).to eq(user_subscription_path(@user, subs))
        expect(page).to have_content('：解約済')
        expect(page).to have_content('解約理由：')
        expect(page).to have_content('詳細：')
        expect(page).to have_content('Price')
        expect(page).to have_content('Period')
        expect(page).to have_content('Review')
      end
    end

    context 'サブスク詳細が確認できないとき' do
      it '解約済のサブスクは、サブスク一覧には表示されず、サブスク一覧からは確認できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        expect(page).to have_no_content(subs.name)
      end

      it 'ログアウト状態では、サブスク詳細ページに遷移できず、ログインページに遷移する' do
        visit user_subscription_path(@user, @subs)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク登録' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.build(:subscription, user_id: @user.id)
    end

    context 'サブスク新規登録ができるとき' do
      it '正しい情報を入力すればサブスク新規登録ができ、マイページに移動する' do
        sign_in_support(@user)
        find_link('Add', href: new_user_subscription_path(@user)).click
        expect(page).to have_content('サブスク登録')
        fill_in 'name', with: @subs.name
        fill_in 'price', with: @subs.price
        fill_in 'contract_date', with: @subs.contract_date
        fill_in 'update_cycle', with: @subs.update_cycle
        find('input[value="2"]').click
        check 'subscription_update_day_type_id'
        expect { find('input[type="submit"]').click }.to change { Subscription.count }.by(1)
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content(@subs.name)
        subs_id = Subscription.find_by(name: @subs.name)
        expect(page).to have_content(ContractRenewal.find_by(subscription_id: subs_id).next_update_date)
      end
    end

    context 'サブスク新規登録ができないとき' do
      it '誤った情報では登録ができず、レンダーで登録ページが表示される' do
        sign_in_support(@user)
        find_link('Add', href: new_user_subscription_path(@user)).click
        expect(page).to have_content('サブスク登録')
        fill_in 'name', with: ''
        fill_in 'price', with: ''
        fill_in 'contract_date', with: ''
        fill_in 'update_cycle', with: ''
        expect { find('input[type="submit"]').click }.to change { Subscription.count }.by(0)
        expect(current_path).to eq(user_subscriptions_path(@user))
        expect(page).to have_content('サブスク名を入力してください')
        expect(page).to have_content('価格を入力してください')
        expect(page).to have_content('価格は0以上の整数を入力してください')
        expect(page).to have_content('契約開始日を入力してください')
        expect(page).to have_content('更新サイクルを入力してください')
      end

      it 'ログアウト状態では、サブスク追加ページに遷移できず、ログインページに遷移する' do
        visit new_user_subscription_path(@user)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク編集' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
    end

    context 'サブスク編集ができるとき' do
      it '正しい情報を入力すればサブスク編集ができ、マイページに移動する' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find_link('編集', href: edit_user_subscription_path(@user, @subs)).click
        expect(page).to have_content('サブスク編集')
        fill_in 'name', with: ''
        fill_in 'name', with: "#{@subs.name[0..1]}変更後サブスク名"
        find('input[type="submit"]').click
        expect { click_button 'OK' }.to change { Subscription.count }.by(0)
        click_button 'OK'
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content("#{@subs.name[0..1]}変更後サブスク名")
      end

      it '正しい情報を入力すればサブスク編集ができ、マイページに移動する' do
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(page).to have_content('編集する')
        find_link('編集する', href: edit_user_subscription_path(@user, @subs)).click
        expect(find('#name').value).to eq(@subs.name)
        expect(find('#price').value).to eq(@subs.price.to_s)
        expect(find('#update_cycle').value).to eq(@subs.update_cycle.to_s)
        fill_in 'name', with: ''
        fill_in 'name', with: "#{@subs.name[0..1]}変更後サブスク名"
        fill_in 'price', with: @subs.price * 2
        fill_in 'update_cycle', with: 1
        find('input[value="2"]').click
        uncheck 'subscription_update_day_type_id'
        find('input[type="submit"]').click
        expect { click_button 'OK' }.to change { Subscription.count }.by(0)
        click_button 'OK'
        expect(current_path).to eq(user_path(@user))
        visit user_subscription_path(@user, @subs)
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        expect(page).to have_content("#{@subs.name[0..1]}変更後サブスク名")
        expect(page).to have_content((@subs.price * 2).to_s)
        expect(page).to have_content('更新サイクル 1 ヶ 月')
      end
    end

    context 'サブスク編集ができないとき' do
      it '誤った情報では編集ができず、編集ページに戻る' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find_link('編集', href: edit_user_subscription_path(@user, @subs)).click
        expect(page).to have_content('サブスク編集')
        fill_in 'name', with: ''
        fill_in 'price', with: ''
        fill_in 'update_cycle', with: ''
        find('input[type="submit"]').click
        click_button 'OK'
        expect(page).to have_content('更新失敗')
        expect(page).to have_content('サブスク名を入力してください')
        click_button 'OK'
        expect(current_path).to eq(edit_user_subscription_path(@user, @subs))
      end

      it '確認画面でキャンセルを選択すると、編集されない' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find_link('編集', href: edit_user_subscription_path(@user, @subs)).click
        expect(page).to have_content('サブスク編集')
        fill_in 'name', with: '編集しよう'
        fill_in 'price', with: '999999'
        fill_in 'update_cycle', with: '33'
        find('input[type="submit"]').click
        click_button 'Cancel'
        expect(current_path).to eq(edit_user_subscription_path(@user, @subs))
        expect(@subs.name).to eq(Subscription.find(@subs.id).name)
        expect(find('input[id="name"]').value).to eq('編集しよう')
      end

      it '解約済のサブスクは、サブスク一覧には表示されず、編集できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        expect(page).to have_no_content(subs.name)
      end

      it '解約済のサブスクは、サブスク詳細ページで編集ボタンが表示されず、編集できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        visit user_subscription_path(@user, subs)
        expect(page).to have_content(subs.name)
        expect(page).to have_content('Price')
        expect(page).to have_content('Period')
        expect(page).to have_content('Review')
        expect(page).to have_no_content('編集する')
      end

      it 'ログアウト状態では、サブスク編集ページに遷移できず、ログインページに遷移する' do
        visit edit_user_subscription_path(@user, @subs)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end

  describe 'サブスク削除' do
    before do
      @user = FactoryBot.create(:user)
      @subs = FactoryBot.create(:subscription, user_id: @user.id)
      @renewal = FactoryBot.create(:contract_renewal, subscription_id: @subs.id)
    end

    context 'サブスク削除ができるとき' do
      it 'ログイン状態なら、サブスクが削除後、マイページに戻る' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find('input[value="削除"]').click
        click_button 'OK'
        sleep(0.1)
        expect(Subscription.count).to eq(0)
        click_button 'OK'
        expect(current_path).to eq(user_path(@user))
      end

      it 'ログイン状態なら、サブスクが削除後、マイページに戻る' do
        sign_in_support(@user)
        find_link('', href: user_subscription_path(@user, @subs)).click
        expect(current_path).to eq(user_subscription_path(@user, @subs))
        find('input[value="削除する"]').click
        click_button 'OK'
        sleep(0.1)
        expect(Subscription.count).to eq(0)
        click_button 'OK'
        expect(current_path).to eq(user_path(@user))
      end

      it 'ログイン状態なら、解約済のサブスクも、詳細ページから削除できる' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_renewal, subscription_id: subs.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        find_link('Cancels', href: user_contract_cancels_path(@user)).click
        expect(current_path).to eq(user_contract_cancels_path(@user))
        expect(page).to have_content(subs.name)
        find_link('', href: user_subscription_path(@user, subs)).click
        expect(current_path).to eq(user_subscription_path(@user, subs))
        expect(page).to have_content('：解約済')
        expect(Subscription.count).to eq(2)
        find('input[value="削除する"]').click
        click_button 'OK'
        sleep(0.1)
        expect(Subscription.count).to eq(1)
        click_button 'OK'
        expect(current_path).to eq(user_path(@user))
      end
    end

    context 'サブスク削除ができないとき' do
      it '確認画面でCancelを選択すると削除されず、マイページへ戻る' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find('input[value="削除"]').click
        click_button 'Cancel'
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content(@subs.name)
      end

      it '確認画面でサブスクの解約はこちらを選択すると削除されず、解約ページへ遷移する' do
        sign_in_support(@user)
        find('.sub-ope-menu').click
        find('input[value="削除"]').click
        find_link('サブスクの解約はこちら', href: new_user_subscription_contract_cancel_path(@user, @subs)).click
        expect(current_path).to eq(new_user_subscription_contract_cancel_path(@user, @subs))
        expect(page).to have_content("#{@subs.name}の解約")
      end

      it '解約済のサブスクは、サブスク一覧には表示されず、サブスク一覧からは削除できない' do
        subs = FactoryBot.create(:subscription, user_id: @user.id)
        FactoryBot.create(:contract_cancel, subscription_id: subs.id)
        sign_in_support(@user)
        expect(page).to have_no_content(subs.name)
      end
    end
  end
end
