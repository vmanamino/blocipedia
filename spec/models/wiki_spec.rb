require 'rails_helper'

describe Wiki do
  before do
    @wikis = create_list(:wiki, 5)
    wiki_private = create(:wiki, private: true)
    @wikis.push(wiki_private) # add one private to test scope
  end
  it 'has working test factory' do
    @wiki = create(:wiki)
    expect(@wiki).to be_valid
  end
  it 'belongs to a user' do
    reflection = Wiki.reflect_on_association(:user)
    expect(reflection.macro).to eq(:belongs_to)
  end
  it 'default value of private is false' do
    @wiki = create(:wiki)
    expect(@wiki.private).to be(false)
  end
  it 'scope limits private wikis to premium users' do
    user = create(:user, role: 'premium')
    expect(Wiki.visible_to(user).count).to eq(6)
  end
  it 'scope keeps private wikis from standard users' do
    user = create(:user)
    expect(Wiki.visible_to(user).count).to eq(5)
  end
end
