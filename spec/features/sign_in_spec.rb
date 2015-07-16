require 'rails_helper'

describe 'Sign in flow' do
  include TestFactories

  describe 'successful' do
    it 'redirects to welcome index view' do
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
    end
  end
end
