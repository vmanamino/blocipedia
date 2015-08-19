require 'rails_helper'

describe User do
  before do
    @user = create(:user)
  end
  it 'has working test factory' do
    expect(@user).to be_valid
  end
  it { should have_many(:wikis) }
  it { should have_many(:collaborators) }
  it { should validate_presence_of(:role) }
  it '.defaults' do # testing private callback for default value
    expect(@user.role).to eq('standard')
  end
  it '.admin' do
    expect(@user.admin?).to eq(false)
  end
  it '.premium' do
    expect(@user.premium?).to eq(false)
  end
  it '.standard' do
    expect(@user.standard?).to eq(true) # this is the default role via callback
  end
  describe '.wikis_collaborator' do
    before do
      @user_other = create(:user)
      @wikis = create_list(:wiki, 5, user: @user_other)
      @collaboration = []
      @wikis.each do |wiki|
        @collaboration.push(create(:collaborator, user: @user, wiki: wiki))
      end
    end
    it 'includes wikis User collaborated on' do
      expect(@user.wikis_collaborator).to eq(@wikis)
    end
    it 'excludes User created wikis' do
      expect(@user.wikis.count).to be(0)
    end
  end
  describe '.downgrade_status' do
    before do
      @wikis = create_list(:wiki, 5, user: @user, private: true)
    end
    it 'called only when role from premium to standard' do
      expect(Wiki.where(user: @user, private: true).count).to eq(5)
      @user.send(:downgrade_status)
      expect(Wiki.where(user: @user, private: false).count).to eq(0)
      expect(Wiki.count).to eq(5)
    end
    context 'role standard' do
      before do
        @user_standard = create(:user) # default role is standard
        @user_standard_wikis = create_list(:wiki, 5, user: @user_standard, private: true)
      end
      it 'owned wikis unchanged when other attribute updated' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.name = 'New Name'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
      it 'owned wikis unchanged when upgraded to premium' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.role = 'premium'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
      it 'owned wikis unchanged when role changed to admin' do
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
        @user_standard.role = 'admin'
        @user_standard.save
        expect(Wiki.where(user: @user_standard, private: true).count).to eq(5)
      end
    end
    context 'role premium' do
      before do
        @user_premium = create(:user, role: 'premium')
        @private_wikis = create_list(:wiki, 5, user: @user_premium, private: true)
      end
      it 'wikis unchanged when another attribute updated' do
        @user_premium.name = 'New Name'
        @user_premium.save
        expect(Wiki.where(user: @user_premium, private: true).count).to eq(5)
      end
      it 'wikis unchanged when role changed to admin' do
        @user_premium.role = 'admin'
        @user_premium.save
        expect(Wiki.where(user: @user_premium, private: true).count).to eq(5)
      end
      it 'wikis\' private value becomes false when role updated/downgraded to standard' do
        @user_premium.role = 'standard'
        @user_premium.save
        @user_premium.reload
        expect(Wiki.where(user: @user_premium, private: true).count).to eq(0)
      end
    end
  end
end
