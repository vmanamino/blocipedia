require 'rails_helper'
require 'application_policy'

include Devise::TestHelpers

describe WikiPolicy do
  subject { WikiPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :edit?, :show?, :create? do
    it_should_behave_like 'application_policy'
  end
  permissions :index? do
    before do
      @wiki_list = create_list(:wiki, 10)
    end
      it 'allows index view of wikis' do
        expect(subject).to permit(@wiki_list)
      end
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