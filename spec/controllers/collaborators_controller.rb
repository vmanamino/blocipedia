require 'rails_helper'

include Devise::TestHelpers
include Warden::Test::Helpers
# Warden.test_mode!

describe CollaboratorsController do
  before do
    @user_premium = create(:user, role: 'premium')
    sign_in @user_premium
  end
  describe '#create' do
    before do
      @user = create(:user)
      @wiki = create(:wiki)
    end
    it 'collaborator by current user' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id }
      @collaborator = assigns(:collaborator)
      expect(flash[:notice]).to eq('This user is a collaborator!')
    end
    context 'creator signed out' do
      before do
        logout
      end
      it 'collaborator creation fails' do
        post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id }
        expect(response).not_to be_successful
      end
    end
    before { post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id } }
    it { should redirect_to(edit_wiki_path(@wiki)) }
    it 'collaborator fails, flash error generated' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: nil }
      expect(flash[:error]).to eq('Please try again to make this user a collaborator!')
    end
  end
  describe '#destroy' do
    before do
      @user = create(:user)
      @wiki = create(:wiki, user: @user_premium)
      @collaborator = create(:collaborator, user: @user, wiki: @wiki)
    end
    it 'collaborator by current user wiki owner' do
      delete :destroy, wiki_id: @wiki.id, id: @collaborator.id
      expect(flash[:notice]).to eq('This user is no longer a collaborator!')
      expect(response).to redirect_to(edit_wiki_path(@wiki))
      expect(Collaborator.find_by(id: @collaborator.id)).to be nil
    end
  end
end
