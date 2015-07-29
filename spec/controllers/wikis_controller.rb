require 'rails_helper'
include Devise::TestHelpers

describe WikisController do
  before do
    @user = create(:user)
    sign_in @user
  end

  describe '#index' do
    before do
      @wiki_list = create_list(:wiki, 10)
    end
    it 'collection of all wikis' do
      get :index
      expect(assigns(:wikis)).to match_array(@wiki_list)
    end
    it 'orders wikis by id' do
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
    it 'a wiki for current user' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great' }
      wiki = assigns(:wiki)
      expect(wiki.user).to eq(@user)
      expect(flash[:notice]).to eq('Your wiki was saved')
    end
    it 'default value of private is false' do
      @wiki = create(:wiki)
      expect(@wiki.private).to be(false)
    end
    it 'redirects to newly created wiki' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body, how great' }
      wiki_path = assigns(:wiki)
      expect(response).to redirect_to(wiki_path)
    end
    it 'fails to save wiki with [invalid] title too short' do
      post :create, wiki: { title: 'my', body: 'this is my body, how great' }
      expect(flash[:error]).to eq('Your wiki failed to save')
    end
    it 'fails to save wiki with [invalid] title too long' do
      post :create, wiki: { title: 'tooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooolooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooongmystriiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiing', body: 'this is my body, how great' } # rubocop:disable Metrics/LineLength
      expect(flash[:error]).to eq('Your wiki failed to save')
    end
    it 'fails to save wiki with [invalid] body too short' do
      post :create, wiki: { title: 'my wiki', body: 'this is my body' }
      expect(flash[:error]).to eq('Your wiki failed to save')
    end
    it 'redirects to new template on failed save of wiki title too short' do
      post :create, wiki: { title: 'my', body: 'this is my body, how great' }
      expect(response).to render_template('new')
    end
  end

  describe '#destroy' do
    before do
      @wiki = create(:wiki, user: @user)
    end
    it 'a wiki for current user' do
      delete :destroy, id: @wiki.id
      expect(flash[:notice]).to eq('Your wiki was deleted successfully.')
      expect(Wiki.find_by(user_id: @user)).to be_nil
      expect(Wiki.count).to eq(0)
    end
    it 'redirects to root' do
      delete :destroy, id: @wiki.id
      expect(flash[:notice]).to eq('Your wiki was deleted successfully.')
      expect(response).to redirect_to root_path
    end
  end

  describe '#edit' do
    before do
      @wiki = create(:wiki)
    end
    it 'renders a template' do
      get :edit, id: @wiki.id
      expect(response).to render_template('edit')
    end
    it 'gets the correct wiki to update' do
      get :edit, id: @wiki.id
      expect(assigns(:wiki)).to eq(@wiki)
    end
  end
  describe '#update' do
    before do
      @wiki = create(:wiki, user: @user)
    end
    it 'updates a wiki for current user' do
      expect(@wiki.title).to eq('My wiki has a title')
      patch :update, id: @wiki.id, wiki: { title: 'my new wiki', body: 'this is my new body, how great', private: true }
      wiki_updated = Wiki.find(@wiki.id)
      expect(wiki_updated.title).to eq('my new wiki')
      expect(wiki_updated.body).to eq('this is my new body, how great')
      expect(wiki_updated.private).to eq(true)
    end
    it 'redirects to updated wiki' do
      patch :update, id: @wiki.id, wiki: { title: 'my new wiki', body: 'this is my new body, how great', private: true }
      wiki_updated = assigns(:wiki)
      expect(response).to redirect_to wiki_updated
    end
    it 'generates error on failed update: invalid title' do
      patch :update, id: @wiki.id, wiki: { title: 'my', body: 'this is my new body, how great', private: true }
      expect(flash[:error]).to eq('Your wiki failed to update')
    end
    it 'redirects to wiki which failed to update' do
      patch :update, id: @wiki.id, wiki: { title: 'my', body: 'this is my new body, how great', private: true }
      expect(response).to redirect_to @wiki
    end
  end
end
