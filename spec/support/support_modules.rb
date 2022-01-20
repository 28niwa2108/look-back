module SupportModules
  def sign_in_support(user)
    visit root_path
    expect(page).to have_content('Login')
    find_link('Login', href: new_user_session_path).click
    expect(page).to have_content('マイページログイン')
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    find('input[type="submit"]').click
    expect(current_path).to eq(user_path(user))
    expect(page).to have_content('My page')
    expect(page).to have_content('Logout')
    expect(page).to have_no_content('Sign up')
    expect(page).to have_no_content('Login')
  end
end
