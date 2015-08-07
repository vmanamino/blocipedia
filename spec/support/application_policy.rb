require 'rails_helper'
include Devise::TestHelpers

shared_examples 'application_policy_index' do
  permissions :index? do
    it 'does not permit view' do
      @wiki_list = create_list(:wiki, 10)
      expect(subject).not_to permit(@wiki_list)
    end
  end
end

shared_examples 'application_policy_show' do
  subject { ApplicationPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :show? do
    it 'does permit view to visitor' do
      youser = double
      expect(subject).to permit(youser, wiki)
    end
  end
end

shared_examples 'application_policy_create' do
  subject { ApplicationPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :create? do
    it 'permits User to create wiki' do
      expect(subject).to permit(user, wiki)
    end
  end
end

shared_examples 'application_policy_new' do
  permissions :new? do
    it_behaves_like 'application_policy_create'
  end
end

shared_examples 'application_policy_update' do
  subject { ApplicationPolicy }
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :update? do
    it 'permits User to update wiki' do
      expect(subject).to permit(user, wiki)
    end
  end
end

shared_examples 'application_policy_edit' do
  permissions :edit? do
    it_behaves_like 'application_policy_update'
  end
end

shared_examples 'application_policy_destroy' do
  permissions :destroy? do
    it_behaves_like 'application_policy_update'
  end
end
