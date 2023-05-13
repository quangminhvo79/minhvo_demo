require 'rails_helper'

RSpec.feature "Login And Register Flows", type: :feature do
  let(:user) { create :user, password: '12345678' }

  scenario 'As a Guest, They can see Login and Register button' do
    visit root_path

    form = page.find('form#new_user')

    expect(form['action']).to include user_session_path
    expect(page).to have_selector('input#user_email')
    expect(page).to have_selector('input#user_password')
    expect(page).to have_selector('input.btn-primary[value=Login]')
    expect(page).to have_selector('.btn', text: 'Register')
  end

  scenario 'User can login' do
    visit root_path

    login(user)
  end

  scenario 'As a User, They can Login or LogOut with email and password' do
    visit root_path

    login(user)

    expect(page).to have_content(user.email)
    expect(page).to have_selector('.btn-primary', text: 'Share Video')

    page.find('.btn.btn-circle.avatar').click()
    click_on 'Logout'

    expect(page).to have_content('Signed out successfully.')
    expect(page).not_to have_selector('.btn-primary', text: 'Share Video')
    expect(page).not_to have_selector('.btn.btn-circle.avatar')
  end

  scenario 'As a Guest, They can Register a user account' do
    visit root_path

    click_on 'Register'

    expect(page.current_path).to eq(new_user_registration_path)

    fill_in 'user_email', with: 'minhvo@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'

    click_on 'Sign up'

    user = User.last
    expect(page.current_path).to eq(root_path)

    expect(page).to have_content('minhvo@gmail.com')
    expect(page).to have_selector('.btn-primary', text: 'Share Video')
  end

  scenario 'As a Guest, I cannot Register a user account with wrong email format' do
    visit new_user_registration_path

    fill_in 'user_email', with: 'minhvo'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content("Email is invalid")
  end

  scenario 'As a Guest, I cannot Register a user account with password confirm not match with password' do
    visit new_user_registration_path

    fill_in 'user_email', with: 'minhvo@gmail.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '123456789'

    click_on 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'As a Guest, I cannot Register a user account with password too short' do
    visit new_user_registration_path

    fill_in 'user_email', with: 'minhvo@gmail.com'
    fill_in 'user_password', with: '123'
    fill_in 'user_password_confirmation', with: '123'

    click_on 'Sign up'

    expect(page).to have_content("Password is too short (minimum is 6 characters)")
  end
end
