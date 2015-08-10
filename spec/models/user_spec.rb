require 'rails_helper'

describe User do
  before do
    @user = create(:user)
  end
  it 'has working test factory' do
    expect(@user).to be_valid
  end
  it 'has many wikis' do
    reflection = User.reflect_on_association(:wikis)
    expect(reflection.macro).to eq(:has_many)
  end
  it 'has default role standard' do # testing private callback for default value
    expect(@user.role).to eq('standard')
  end
  it 'has public method admin with boolean values' do
    expect(@user.admin?).to eq(false)
  end
  it 'has public method premium with boolean values' do
    expect(@user.premium?).to eq(false)
  end
  it 'has public method standard with boolean values' do
    expect(@user.standard?).to eq(true) # this is the default role via callback
  end
  describe 'downgrade_status method' do
    before do
      @wikis = create_list(:wiki, 5, user: @user, private: true)
    end
    it 'changes all private wikis to public' do
      expect(Wiki.where(private: true).count).to eq(5)
      @user.send(:downgrade_status)
      expect(Wiki.where(private: false).count).to eq(5)
      expect(Wiki.count).to eq(5)
    end
  end
end
