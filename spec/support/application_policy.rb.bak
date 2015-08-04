require 'rails_helper'
include Devise::TestHelpers

shared_examples 'application_policy' do
  subject { ApplicationPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :edit? do
    it 'allows user owner to edit record' do
      expect(subject).to permit(user, wiki)
    end
    it 'allows user to edit record of another user' do
      expect(subject).to permit(create(:user), wiki)
    end
  end
  permissions :create? do
    it 'successful when permissions match' do
      expect(subject).to permit(user, wiki)
    end
  end
  permissions :show? do
    it 'successful show to web site visitor' do
      youser = double
      expect(subject).to permit(youser, wiki)
    end
  end
end
