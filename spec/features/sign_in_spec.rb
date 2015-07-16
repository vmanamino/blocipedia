require 'rails_helper'

describe 'Sign in flow' do
  # include TestFactories

  describe 'successful' do
    it 'redirects to welcome index view and indicates sign-in status' do
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
        expect(page).to have_content(user.email)
        expect(page).to have_content('Hello')
        find_link('Sign out').visible?
      end   
        
    end
  end
end
