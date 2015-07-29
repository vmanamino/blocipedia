require 'rails_helper'

describe User do
  it 'has working test factory' do
    @user = create(:user)
    expect(@user).to be_valid
  end
  it 'has many wikis' do
    reflection = User.reflect_on_association(:wikis)
    expect(reflection.macro).to eq(:has_many)
  end
end
