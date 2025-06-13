require 'rails_helper'

RSpec.describe 'User updates profile', type: :system do
  let(:user) { create(:user, email: 'email@gmail.com', password: 'password') }

  before do
    sign_in user
  end

  scenario 'user redirects to login page after password change' do
    visit root_path

    expect(page).to have_content('Welcome email@gmail.com')

    click_button 'Edit Profile'

    fill_in 'Current password', with: user.password
    fill_in 'Password', with: 'new_password'
    fill_in 'Password confirmation', with: 'new_password'
    click_button 'Update'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_content('Log in')
  end

  context 'when keep logged in checked' do
    scenario 'user redirects to root page after password change' do
      visit root_path

      expect(page).to have_content('Welcome email@gmail.com')

      click_button 'Edit Profile'

      fill_in 'Current password', with: user.password
      fill_in 'Password', with: 'new_password'
      fill_in 'Password confirmation', with: 'new_password'
      check 'Keep logged in on this browser?'
      click_button 'Update'

      expect(page).to have_content('Welcome email@gmail.com')
    end
  end

  context 'when update email only' do
    scenario 'user redirects to root page after password change' do
      visit root_path

      expect(page).to have_content('Welcome email@gmail.com')

      click_button 'Edit Profile'

      fill_in 'Email', with: 'email1@gmail.com'
      click_button 'Update'

      expect(page).to have_content('You have to confirm your email address before continuing.')
      expect(page).to have_content('Log in')
    end
  end

  context 'when update profile with invalid data' do
    scenario 'user redirects to root page after password change' do
      visit root_path

      expect(page).to have_content('Welcome email@gmail.com')

      click_button 'Edit Profile'

      fill_in 'Current password', with: user.password
      fill_in 'Password', with: 'new_password1'
      fill_in 'Password confirmation', with: 'new_password2'
      click_button 'Update'

      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
