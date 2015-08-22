require 'rails_helper'

describe Wiki do
  before do
    @user = create(:user, role: 'premium')
    @wikis = create_list(:wiki, 5)
    wiki_private = create(:wiki, user_id: @user.id, private: true)
    @wikis.push(wiki_private) # add one private to test scope
    @user_two = create(:user, role: 'premium') # premium user to test scope
    # private wiki owned by premium user
    wiki_private_premium_owner = create(:wiki, user_id: @user_two.id, private: true)
    @wikis.push(wiki_private_premium_owner) # total is 7 wikis, 6 will be visible to @user_two
  end
  it 'has working test factory' do
    @wiki = create(:wiki)
    expect(@wiki).to be_valid
  end
  it { should belong_to(:user) }
  it { should have_many(:users) }
  it { should validate_presence_of(:user) }
  it { should have_many(:collaborators) }
  it 'private default is false' do
    @wiki = create(:wiki)
    expect(@wiki.private).to be(false)
  end
  describe '.visible_to' do
    before do
      @collaborator = create(:user)
      @wikis_private_collaborator = create_list(:wiki, 2, private: true)
      @wikis_private_collaborator.each do |wiki|
        create(:collaborator, user: @collaborator, wiki: wiki)
      end
      @wikis_public_collaborator = create_list(:wiki, 2)
      @wikis_public_collaborator.each do |wiki|
        create(:collaborator, user: @collaborator, wiki: wiki)
      end
      @collaborator_other = create(:user)
      @wikis_private_other_collaborator = create_list(:wiki, 2, private: true)
      @wikis_private_other_collaborator.each do |wiki|
        create(:collaborator, user: @collaborator_other, wiki: wiki)
      end
      @wikis_public_other_collaborator = create_list(:wiki, 2)
      @wikis_public_other_collaborator.each do |wiki|
        create(:collaborator, user: @collaborator_other, wiki: wiki)
      end
      @wikis_public_no_collaborator = create_list(:wiki, 2)
      @wikis_private_collaborator_is_owner = create_list(:wiki, 2, user: @collaborator, private: true)
    end
    it 'includes private wikis collaborated on' do
      wikis = Wiki.visible_to(@collaborator)
      collaborations = []
      wikis.each do |wiki|
        if wiki.private == true && wiki.user_id != @collaborator.id
          collaborations.push(wiki)
        end
      end
      expect(collaborations).to eq(@wikis_private_collaborator)
    end
    it 'includes public wikis collaborated on' do
      wikis = Wiki.visible_to(@collaborator)
      expect(wikis.include?(@wikis_public_collaborator[0])).to be true
      expect(wikis.include?(@wikis_public_collaborator[1])).to be true
    end
    it 'excludes private wikis of another collaborator' do
      wikis = Wiki.visible_to(@collaborator)
      expect(wikis.include?(@wikis_private_other_collaborator[0])).to be false
      expect(wikis.include?(@wikis_private_other_collaborator[1])).to be false
    end
    it 'includes public wikis of another collaborator' do
      wikis = Wiki.visible_to(@collaborator)
      expect(wikis.include?(@wikis_public_other_collaborator[0])).to be true
      expect(wikis.include?(@wikis_public_other_collaborator[1])).to be true
    end
    it 'includes public wikis with no collaborator' do
      wikis = Wiki.visible_to(@collaborator)
      expect(wikis.include?(@wikis_public_no_collaborator[0])).to be true
      expect(wikis.include?(@wikis_public_no_collaborator[1])).to be true
    end
    it 'includes owned private wikis' do
      wikis = Wiki.visible_to(@collaborator)
      expect(wikis.include?(@wikis_private_collaborator_is_owner[0])).to be true
      expect(wikis.include?(@wikis_private_collaborator_is_owner[1])).to be true
    end
    xit 'does not include public wikis collaborated on more than once' do

    end
  end
  describe 'user_collaborators method' do
    before do
      @wiki_collaboration = create(:wiki)
      @users = create_list(:user, 5)
      @collaboration = []
      @users.each do |collaborator|
        @collaboration.push(create(:collaborator, user: collaborator, wiki: @wiki_collaboration))
      end
    end
    it 'returns all users who collaborated on a wiki' do
      expect(@wiki_collaboration.user_collaborators).to eq(@users)
    end
  end
end
