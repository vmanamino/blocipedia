require 'rails_helper'

describe User do
  before do
    @user = create(:user)
  end
  it 'has working test factory' do
    expect(@user).to be_valid
  end
  it { should have_many(:wikis) }
  it { should validate_presence_of(:role) }
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
    it 'cannot be called unless User role is changed' do
      expect(Wiki.where(user: @user, private: true).count).to eq(5)
      @user.send(:downgrade_status)
      expect(Wiki.where(user: @user, private: false).count).to eq(0)
      expect(Wiki.count).to eq(5)
    end
    describe 'when Standard User' do
      before do
        @user_standard = create(:user) # default role is standard
        @user_standard_wikis = create_list(:wiki, 5, user: @user_standard, private: true)
      end
      it 'wikis stay private if attribute other than role is changed' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.name = 'New Name'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
      it 'wikis stay private if role is upgraded to premium' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.role = 'premium'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
      it 'wikis stay the same if role is changed to admin' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.role = 'admin'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
    end
    describe 'when Premium User' do
      before do
        @user_premium = create(:user, role: 'premium')
        @private_wikis = create_list(:wiki, 5, user: @user_premium, private: true)
      end
      it 'wikis stay private if attribute other than role is changed' do
        @user_premium.name = 'New Name'
        @user_premium.save
        expect(Wiki.where(user: @user_premium, private: true).count).to eq(5)
      end
      it 'wikis stay private if premium user is changed to admin user' do
        @user_premium.role = 'admin'
        @user_premium.save
        expect(Wiki.where(user: @user_premium, private: true).count).to eq(5)
      end
      it 'wikis change to public if role is updated/downgraded to standard' do
        @user_premium.role = 'standard'
        @user_premium.save
        expect(Wiki.where(user: @user_premium, private: false).count).to eq(5)
      end
    end
  end
end
