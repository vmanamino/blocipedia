require 'rails_helper'
include Devise::TestHelpers
require 'pundit/rspec'
require 'application_policy'

describe CollaboratorPolicy do
  subject { CollaboratorPolicy }
  let(:user) { create(:user) }
  let(:visitor) { nil }
  let(:collaborator) { create(:user) }
  let(:wiki) { create(:wiki) }
  permissions :index? do
    it_behaves_like 'application_policy_index'
  end
  permissions :show? do
    before do
      @user_premium = create(:user, role: 'premium')
      @wiki = create(:wiki, user: @user_premium)
      @collaboration = create(:collaborator, user: collaborator, wiki: @wiki)
    end
    it 'false' do
      expect(subject).not_to permit(user, @collaboration)
      expect(subject).not_to permit(@user, @collaboration)
    end
  end
  permissions :create? do
    before do
      @user_premium = create(:user, role: 'premium')
      @user_premium_other = create(:user, role: 'premium')
      @wiki = create(:wiki, user: @user_premium)
    end
    it 'permits premium user owner' do
      expect(subject).to permit(@user_premium, create(:collaborator, user: collaborator, wiki: @wiki))
    end
    it 'permits to premium user not owner' do # want to change/deny this
      expect(subject).to permit(@user_premium_other, create(:collaborator, user: collaborator, wiki: @wiki))
    end
    it 'denies standard user' do
      expect(subject).not_to permit(user, create(:collaborator, user: collaborator, wiki: create(:wiki, user: user)))
    end
    it 'denies site vistor' do
      expect(subject).not_to permit(visitor, create(:collaborator, user: collaborator, wiki: create(:wiki, user: user)))
    end
  end
  permissions :destroy? do
    before do
      @user_premium = create(:user, role: 'premium')
      @user_premium_other = create(:user, role: 'premium')
      @wiki = create(:wiki, user: @user_premium)
    end
    it 'permitted to premium user owner' do
      expect(subject).to permit(@user_premium, create(:collaborator, user: collaborator, wiki: @wiki))
    end
    it 'denied to premium user not owner' do
      expect(subject).not_to permit(@user_premium_other, create(:collaborator, user: collaborator, wiki: @wiki))
    end
  end
end
