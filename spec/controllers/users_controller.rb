require 'rails_helper'
include Devise::TestHelpers

describe UsersController do
  before do
    @current_user = create(:user, role: 'premium')
    sign_in @current_user
  end
  describe 'show action' do
    before do
      @wiki_collection = create_list(:wiki, 5, user: @current_user)
      @private_wikis = create_list(:wiki, 5, user: @current_user, private: true)
      @wiki_collection.push(@private_wikis)
    end
    it 'collects private wikis belonging to current user' do
      wikis = Wiki.all
      expect(wikis.where(user: @current_user, private: true).count).to eq(5)
      get :show, id: @current_user
      wikis = assigns(:wikis_private)
      expect(wikis.where(private: true).count).to eq(5)
    end
    it 'collects public wikis belonging to current user' do
      wikis = Wiki.all
      expect(wikis.where(user: @current_user, private: false).count).to eq(5)
      get :show, id: @current_user
      wikis = assigns(:wikis_public)
      expect(wikis.where(private: false).count).to eq(5)
    end
  end
  describe 'update action' do
    it 'updates/downgrades premium user to standard' do
      patch :update, id: @current_user.id, user: { role: 'standard' }
      @current_user.reload
      expect(@current_user.role).to eq('standard')
    end
    it 'redirects to current user show view on successful update' do
      patch :update, id: @current_user.id, user: { role: 'standard' }
      expect(response).to redirect_to(@current_user)
    end
    it 'generates flash notice on updating' do
      patch :update, id: @current_user.id, user: { role: 'standard' }
      expect(flash[:notice]).to eq('Your account was downgraded')
    end
    it 'generates flash error on failing to update' do
      patch :update, id: @current_user.id, user: { role: '' }
      expect(flash[:error]).to eq('Your account failed to downgrade')
    end
    it 'redirects to curent user show view on failed update ' do
      patch :update, id: @current_user.id, user: { role: '' }
      expect(response).to redirect_to(@current_user)
    end
    describe 'user model callback to downgrade status on update' do
      before do
        @wikis = create_list(:wiki, 5, user: @current_user, private: true)
      end
      it 'makes all associated wikis public by setting private to false' do
        wikis = Wiki.where(user: @current_user)
        expect(wikis.where(private: true).count).to eq(5)
        patch :update, id: @current_user.id, user: { role: 'premium' }
        wikis = Wiki.where(user: @current_user)
        expect(wikis.where(private: false).count).to eq(5)
      end
    end
  end
end