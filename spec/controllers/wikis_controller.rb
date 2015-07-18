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
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great', private: false, user_id: @user.id }
      expect(Wiki.count).to eq(1)
      wiki = Wiki.find_by(user_id: @user)
      expect(wiki.title).to eq('my wiki')
      expect(response).to redirect_to wiki
    end
    it 'redirects to newly created wiki' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great', private: false, user_id: @user.id }
      wiki = Wiki.find_by(user_id: @user)
      expect(response).to redirect_to wiki
    end
  end

  describe '#destroy' do
    it 'destroys a wiki for current user' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great now', private: false)
      wiki.save
      expect(@user.wikis).not_to be_nil
      expect(Wiki.count).to eq(1)
      delete :destroy, id: wiki.id, user_id: @user.id
      expect(Wiki.find_by(user_id: @user)).to be_nil
      expect(Wiki.count).to eq(0)
    end
    it 'redirects to root' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great now', private: false)
      wiki.save
      delete :destroy, id: wiki.id, user_id: @user.id
      expect(response).to redirect_to root_path
    end
  end

  describe '#update' do
    it 'updates a wiki for current user' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great', private: false)
      wiki.save
      expect(wiki.title).to eq('my wiki')
      patch :update, id: wiki.id, wiki: { title: 'my new wiki', body: 'this is my new body, how great', private: true }
      wiki_new = Wiki.find_by(user_id: @user)
      expect(wiki_new.title).not_to eq(wiki.title)
      expect(wiki_new.title).to eq('my new wiki')
      expect(wiki_new.body).not_to eq(wiki.body)
      expect(wiki_new.body).to eq('this is my new body, how great')
      expect(wiki_new.private).not_to eq(wiki.private)
      expect(wiki_new.private).to eq(true)
    end
    it 'redirects to updated wiki' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great', private: false)
      wiki.save
      patch :update, id: wiki.id, wiki: { title: 'my new wiki', body: 'this is my new body, how great', private: true }
      expect(response).to redirect_to wiki
    end
  end
end
