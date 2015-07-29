require 'rails_helper'
describe 'Sign out flow' do
  describe 'Successful sign out' do
    it 'redirects to the welcome index view and indicates successful sign out' do
      user = create(:user)
      visit root_path
      within('.user-info') do
        click_link 'Sign In'
      end
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      within 'form' do
        click_button 'Sign in'
      end

      within('.user-info') do
        click_link 'Sign out'
      end

      within('.container') do
        expect(page).to have_content('Signed out successfully')
      end

      within('.user-info') do
        find_link('Sign In').visible?
        expect(page).not_to have_content('Sign out')
      end
      expect(current_path).to eq root_path
    end
  end
end
