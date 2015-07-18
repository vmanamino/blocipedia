require 'rails_helper'

describe Wiki do
  it 'has working test factory' do
    @wiki = create(:wiki)
    expect(@wiki).to be_valid
  end
end
