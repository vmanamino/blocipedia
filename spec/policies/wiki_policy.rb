require 'rails_helper'
require 'application_policy'

include Devise::TestHelpers

describe WikiPolicy do
  subject { WikiPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :index? do
    before do
      @wiki_list = create_list(:wiki, 10)
    end
    it 'permits view of all wikis' do
      expect(subject).to permit(@wiki_list)
    end
  end
  permissions :show? do
    before do
      @premium_user_owner = create(:user, role: 'premium')
      @private_wiki = create(:wiki, private: true, user: @premium_user_owner)
      @premium_user_other = create(:user, role: 'premium')
      @standard_user_other = create(:user)
      @admin_user = create(:user, role: 'admin')
      @visitor = double
    end
    it 'permits view of private wiki to premium user owner' do
      expect(subject).to permit(@premium_user_owner, @private_wiki)
    end
    it 'denies view of private wiki to another premium user' do
      expect(subject).not_to permit(@premium_user_other, @private_wiki)
    end
    it 'denies view of private wiki to a given standard user' do
      expect(subject).not_to permit(user, @private_wiki)
    end
    it 'permits view of public wiki to a given premium user' do
      expect(subject).to permit(@premium_user_owner, wiki)
    end
    it 'permits view of public wiki to a given standard user' do
      expect(subject).to permit(user, wiki)
    end
    it 'permits view of private wiki to a given admin user' do
      expect(subject).to permit(@admin_user, @private_wiki)
    end
    it 'permits view of public wiki to a given admin user' do
      expect(subject).to permit(@admin_user, wiki)
    end
    it 'permits view of public wiki to a site visitor' do
      expect(subject).to permit(@visitor, wiki)
    end
  end
  permissions :create? do
    it_behaves_like 'application_policy_create'
  end
  permissions :new?  do
    it_behaves_like 'application_policy_new'
  end
  permissions :update? do
    before do
      @premium_user_owner = create(:user, role: 'premium')
      @private_wiki = create(:wiki, private: true, user: @premium_user_owner)
      @premium_user_other = create(:user, role: 'premium')
      @standard_user_other = create(:user)
      @admin_user = create(:user, role: 'admin')
    end
    it 'permits user owner to update wiki' do
      expect(subject).to permit(@premium_user_owner, @private_wiki)
      expect(subject).to permit(user, wiki)
    end
    it 'denies updating wiki to another user' do
      expect(subject).not_to permit(@standard_other_user, wiki)
      expect(subject).not_to permit(@premium_user_other, @private_wiki)
    end
  end
  permissions :edit? do
    it_behaves_like 'application_policy_edit'
  end
  permissions :destroy? do
    it 'allows user owner to destroy wiki' do
      expect(subject).to permit(user, wiki)
    end
    it 'allows admin user to destroy wiki' do
      expect(subject).to permit(create(:user, role: 'admin'), wiki)
    end
    it 'does not allow other user to destroy wiki' do
      expect(subject).not_to permit(create(:user), wiki)
    end
  end
end
