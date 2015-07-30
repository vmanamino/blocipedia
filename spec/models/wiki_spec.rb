require 'rails_helper'

describe Wiki do
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
end
