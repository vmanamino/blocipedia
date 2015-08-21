require 'rails_helper'

include Devise::TestHelpers

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
      expect(flash[:notice]).to eq('Successfully made this user a collaborator!')
    end
    it 'collaborator belongs to user' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id }
      collaborators = Collaborator.where(user_id: @user.id).all
      expect(collaborators.all? { |c| c.user_id == @user.id }).to be true
    end
    it 'collaborator belongs to wiki' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id }
      collaborators = Collaborator.where(wiki_id: @wiki.id).all
      expect(collaborators.all? { |c| c.user_id == @user.id }).to be true
    end
    before { post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: @wiki.id } }
    it { should redirect_to(edit_wiki_path(@wiki)) }
    it 'collaborator fails, flash error generated' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: nil, wiki_id: @wiki.id }
      expect(flash[:error]).to eq('Please try again to make this user a collaborator!')
    end
    it 'collaborator fails, then it redirects to wiki' do
      post :create, wiki_id: @wiki.id, collaborator: { user_id: @user.id, wiki_id: nil }
      expect(response).to redirect_to(edit_wiki_path(@wiki))
    end
  end
  describe '#destroy' do
    before do
      @user = create(:user)
      @wiki = create(:wiki)
      @collaborator = create(:collaborator, user: @user, wiki: @wiki)
    end
    it 'collaborator by current user' do
      delete :destroy, wiki_id: @wiki.id, id: @collaborator.id
      expect(flash[:notice]).to eq('This user is no longer a collaborator!')
      expect(response).to redirect_to(edit_wiki_path(@wiki))
      expect(Collaborator.find_by(id: @collaborator.id)).to be nil
    end
  end
end