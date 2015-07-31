require 'rails_helper'
include Devise::TestHelpers

describe WikiPolicy do
  subject { WikiPolicy } # rubocop:disable Style/TrailingWhitespace
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  permissions :edit? do
    it 'allows owner to edit record' do
      expect(subject).to permit(user, wiki)
    end
    it 'does not allow user to edit record of another user' do
      expect(subject).to permit(create(:user), wiki)
    end
  end
  permissions :update? do
    it 'allows a standard user to edit public wiki of another' do
      expect(subject).to permit(create(:user, role: 'standard'), create(:wiki, private: false))
    end # rubocop:disable Style/TrailingBlankLines
    it 'RIGHT NOW does allow standard user to update private wiki of another' do # this needs to change
      expect(subject).to permit(create(:user, role: 'standard'), create(:wiki, private: true))
    end
  end
  permissions :destroy? do
    it 'allows owner to delete record' do
      expect(subject).to permit(user, wiki)
    end
    it 'allows admin to delete record' do
      expect(subject).to permit(create(:user, role: 'admin'), wiki)
    end
    it 'does not permit user to delete record of another user' do
      expect(subject).not_to permit(create(:user), wiki)
    end
  end
end
