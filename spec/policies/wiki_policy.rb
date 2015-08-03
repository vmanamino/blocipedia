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
      @private_wiki = create(:wiki, private: true)
    end
    it 'permits view to premium user' do
      user = create(:user, role: 'premium')
      expect(subject).to permit(user, @private_wiki)
    end
    it 'permits view to admin user' do
      user = create(:user, role: 'admin')
      expect(subject).to permit(user, @private_wiki)
    end
    it 'denies view to standard user' do
      user = create(:user, role: 'standard')
      expect(subject).not_to permit(user, @private_wiki)
    end
  end
  permissions :create? do
    it_behaves_like 'application_policy_create'
  end
  permissions :new?  do
    it_behaves_like 'application_policy_new'
  end
  permissions :update? do
    it_behaves_like 'application_policy_update'
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
