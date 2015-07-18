require 'rails_helper'
include Devise::TestHelpers

describe WikisController do
  before do
    @user = create(:user)
    sign_in @user
  end
  
  describe '#create' do
    it 'creates a wiki for current user' do
      expect(Wiki.find_by(user_id: @user)).to be_nil      
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great', private: false)
      expect(wiki.user_id).to eq(@user.id)
    end
  end
  
  describe '#destroy' do
    it 'destroys a wiki for current user' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great', private: false)
      wiki.save
      expect(@user.wikis.find_by(user_id: @user.id)).to_not be_nil
      delete :destroy, {id: wiki.id, user_id: @user.id}
      expect(@user.wikis.find_by(user_id: @user.id)).to be_nil      
    end
  end
end
