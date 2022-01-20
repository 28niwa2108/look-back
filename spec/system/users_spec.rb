require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  describe 'ユーザー新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end

    context 'ユーザー新規登録ができるとき' do
      it '正しい情報を入力すればユーザー新規登録ができ、マイページに移動する' do
        visit root_path
        expect(page).to have_content('Sign up')
        find_link('Sign up', href: new_user_registration_path).click
        expect(page).to have_content('アカウント作成')
        fill_in 'nickname', with: @user.nickname
        fill_in 'email', with: @user.email
        fill_in 'password', with: @user.password
        fill_in 'password_confirmation', with: @user.password_confirmation
        expect { find('input[type="submit"]').click }.to change { User.count }.by(1)
        expect(current_path).to eq(user_path(User.find_by(email: @user.email)))
        expect(page).to have_content('My page')
        expect(page).to have_content('Logout')
        expect(page).to have_no_content('Sign up')
        expect(page).to have_no_content('Login')
      end
    end

    context 'ユーザー新規登録ができないとき' do
      it '誤った情報ではユーザー新規登録ができず、新規登録ページにレンダーで戻る' do
        visit root_path
        expect(page).to have_content('Sign up')
        find_link('Sign up', href: new_user_registration_path).click
        expect(page).to have_content('アカウント作成')
        fill_in 'nickname', with: ''
        fill_in 'email', with: ''
        fill_in 'password', with: ''
        fill_in 'password_confirmation', with: ''
        expect { find('input[type="submit"]').click }.to change { User.count }.by(0)
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_content('アカウント作成')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(page).to have_content('パスワードを入力してください')
        expect(page).to have_content('ニックネームを入力してください')
      end
    end
  end

  describe 'ユーザーログイン' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'ユーザーログインができるとき' do
      it '正しい情報を入力すればユーザーログインができ、マイページに移動する' do
        visit root_path
        expect(page).to have_content('Login')
        find_link('Login', href: new_user_session_path).click
        expect(page).to have_content('マイページログイン')
        fill_in 'email', with: @user.email
        fill_in 'password', with: @user.password
        find('input[type="submit"]').click
        expect(current_path).to eq(user_path(@user))
        expect(page).to have_content('My page')
        expect(page).to have_content('Logout')
        expect(page).to have_no_content('Sign up')
        expect(page).to have_no_content('Login')
      end
    end

    context 'ユーザーログインができないとき' do
      it '誤った情報ではユーザーログインができず、ログインページにレンダーで戻る' do
        visit root_path
        expect(page).to have_content('Login')
        find_link('Login', href: new_user_session_path).click
        expect(page).to have_content('マイページログイン')
        fill_in 'email', with: ''
        fill_in 'password', with: ''
        find('input[type="submit"]').click
        expect(current_path).to eq(user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('メールアドレスまたはパスワードが違います。')
      end
    end
  end

  describe 'ユーザーログアウト' do
    before do
      @user = FactoryBot.create(:user)
    end

    context 'ログアウトができるとき' do
      it 'ログイン状態ならログアウトができ、トップページに移動する' do
        sign_in_support(@user)
        expect(page).to have_content('Logout')
        find_link('Logout', href: destroy_user_session_path).click
        expect(current_path).to eq(root_path)
        expect(page).to have_no_content('My page')
        expect(page).to have_no_content('Logout')
        expect(page).to have_content('Sign up')
        expect(page).to have_content('Login')
      end
    end

    context 'ログアウトができないとき' do
      it 'ログアウト状態では、ログアウトができず、ログインページに遷移する' do
        visit destroy_user_session_path
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('マイページログイン')
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end
  end
end
