require 'rails_helper'

describe Collaborator do
  before do
    @user = create(:user)
    @wiki = create(:wiki)
    @collaborator = create(:collaborator, user: @user, wiki: @wiki)
  end
  it 'has Factory' do
    expect(@collaborator).to be_valid
  end
  it { should belong_to(:user) }
  it { should belong_to(:wiki) }
  it 'references user' do
    expect(@collaborator.user).to be(@user)
  end
  it 'references wiki' do
    expect(@collaborator.wiki).to be(@wiki)
  end
  context 'User as Collaborator' do
    before do
      @user_other = create(:user)
      @wiki_other = create(:wiki, user: @user_other)
      @wiki_another = create(:wiki, user: @user_other)
      @wikis = create_list(:wiki, 5, user: @user)
      @collaboration_second = create(:collaborator, user: @user, wiki: @wiki_other)
      @collaboration_third = create(:collaborator, user: @user, wiki: @wiki_another)
    end
    it 'may have many Wikis' do
      wikis = Collaborator.where(user: @user).pluck(:wiki_id)
      expect(wikis.count).to eq(3)
    end
  end
  context 'a Wiki' do
    before do
      @wiki = create(:wiki)
      @wiki_owner = create(:user)
      @collaborators = create_list(:user, 5)
      @collaboration = []
      @collaborators.each do |collaborator|
        @collaboration.push(create(:collaborator, user: collaborator, wiki: @wiki))
      end
    end
    it 'may have many Collaborators' do
      expect(Collaborator.where(wiki: @wiki).count).to eq(5)
    end
  end
  describe '.name' do
    before do
      @user = create(:user)
      @wiki = create(:wiki)
      @collaborator = create(:collaborator, user: @user, wiki: @wiki)
    end
    it 'name of collaborator from user' do
      expect(@collaborator.name).to eq(@user.name)
    end
  end
end
