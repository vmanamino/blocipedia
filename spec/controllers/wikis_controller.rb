require 'rails_helper'
include Devise::TestHelpers

describe WikisController do
  before do
    @user = create(:user)
    sign_in @user       
  end
  
  describe '#index' do
    it 'collection of all wikis' do
      10.times do create(:wiki)      
      end
      wikis = Wiki.all
      get :index      
      expect(assigns(:wikis)).to match_array(wikis)            
    end
    it 'orders wikis by id' do
      10.times do create(:wiki)      
      end
      get :index
      wikis = assigns(:wikis)
      n = 1
      wikis.each do |w|
        expect(w.id).to eq(n)
        n += 1
      end
    end
  end

  describe '#show' do
    it 'displays a wiki by id' do
      wiki = create(:wiki)
      get :show, id: wiki.id
      expect(assigns(:wiki)).to eq(wiki)
    end
  end
  
  describe '#new' do
    it 'renders a new template' do
      get :new
      expect(response).to render_template('new')
    end
    it 'instantiates a new empty wiki' do
      get :new
      wiki = assigns(:wiki)
      expect(wiki.id).to be_nil      
    end
  end
  describe '#create' do
    it 'creates a wiki for current user' do
      expect(Wiki.find_by(user_id: @user)).to be_nil
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great', private: false, user_id: @user.id }
      expect(Wiki.count).to eq(1)
      wiki = Wiki.find_by(user_id: @user)
      expect(wiki.title).to eq('my wiki')
      expect(wiki.user_id).to eq(@user.id)
      expect(wiki.id).to eq(1)
    end
    it 'redirects to newly created wiki' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great', private: false, user_id: @user.id }
      wiki = Wiki.find_by(user_id: @user)
      expect(response).to redirect_to wiki
    end
    it 'fails to save wiki with [invalid] title too short' do
      post :create, wiki: { title: 'my', body: 'this is my body, how great', private: false, user_id: @user.id }
      expect(flash[:error]).to eq('Your wiki failed to save')
    end
    it 'fails to save wiki with [invalid] title too long' do
      post :create, wiki: { title: 'tooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooolooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooongmystriiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiing', body: 'this is my body, how great', private: false, user_id: @user.id }
      expect(flash[:error]).to eq('Your wiki failed to save')
      expect(Wiki.count).to eq(0)
    end
    it 'fails to save wiki with [invalid] body too short' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body', private: false, user_id: @user.id }
      expect(flash[:error]).to eq('Your wiki failed to save')
      expect(Wiki.count).to eq(0)
    end
    it 'fails to save wiki with no user' do
      post :create, wiki: { title: 'my', body: 'this is my body, how great', private: false }
      expect(flash[:error]).to eq('Your wiki failed to save')
      expect(Wiki.count).to eq(0)      
    end
    it 'redirects to new template on failed save of wiki with duplicate id' do
      wiki_other = @user.wikis.build(title: 'my other wiki', body: 'this is my other, how great now', private: false)
      wiki_other.save
      post :create, wiki: {id: wiki_other.id, title: 'my', body: 'this is my body, how great', private: false, user_id: @user.id }
      expect(flash[:error]).to eq('Your wiki failed to save')
      expect(response).to render_template('new')
    end
  end

  describe '#destroy' do
    it 'a wiki for current user' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great now', private: false)
      wiki.save
      expect(@user.wikis).not_to be_nil
      expect(Wiki.count).to eq(1)
      delete :destroy, id: wiki.id, user_id: @user.id
      expect(flash[:notice]).to eq('Your wiki was deleted successfully.')
      expect(Wiki.find_by(user_id: @user)).to be_nil
      expect(Wiki.count).to eq(0)
    end
    it 'redirects to root' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great now', private: false)
      wiki.save
      delete :destroy, id: wiki.id 
      expect(flash[:notice]).to eq('Your wiki was deleted successfully.')
      expect(response).to redirect_to root_path
    end    
  end

  describe '#edit' do
    it 'renders a template' do
      wiki = create(:wiki)
      get :edit, id: wiki.id
      expect(response).to render_template('edit')
    end
    it 'gets the correct wiki to update' do
      wiki = create(:wiki)
      get :edit, id: wiki.id
      expect(assigns(:wiki)).to eq(wiki)
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
    it 'generates error on failed update: invalid title' do
      wiki = @user.wikis.build(title: 'my wiki', body: 'this is my body, how great', private: false)
      wiki.save
      patch :update, id: wiki.id, wiki: { title: 'my', body: 'this is my new body, how great', private: true } # invalid title
      expect(flash[:error]).to eq('Your wiki failed to update')
    end    
  end
end
