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

  it 'default value of private is false' do
    @wiki = create(:wiki)
    expect(@wiki.private).to be(false)
  end
  it 'scope returns private wikis that belongs to a given premium user only' do
    wikis = Wiki.visible_to(@user_two)
    private_wiki = wikis.where(private: true)
    expect(private_wiki[0].user_id).to eq(@user_two.id)
    wikis = Wiki.visible_to(@user)
    private_wiki = wikis.where(private: true)
    expect(private_wiki[0].user_id).not_to eq(@user_two.id)
    expect(private_wiki[0].user_id).to eq(@user.id)
  end
  it 'scope returns all public wikis to a given premium user' do
    wikis = Wiki.visible_to(@user_two)
    public_wikis = wikis.where(private: false)
    expect(public_wikis.count).to eq(5)
  end

end
