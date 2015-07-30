require 'rails_helper'
include Devise::TestHelpers

describe WikiPolicy do
  subject { WikiPolicy } # rubocop:disable Style/TrailingWhitespace
  permissions :update? do
    it 'allows a standard user to edit public wiki of another' do
      expect(subject).to permit(User.new(role: 'standard'), Wiki.new(private: false))
    end # rubocop:disable Style/TrailingBlankLines
    it 'RIGHT NOW does allow standard user to edit private wiki of another' do
      expect(subject).to permit(User.new(role: 'standard'), Wiki.new(private: true))
    end
  end
end
