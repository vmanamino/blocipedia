require 'rails_helper'

describe Collaborator do
  before do
    @collaborator = create(:collaborator)
  end
  it 'has Factory' do
    expect(@collaborator).to be_valid
  end
  it { should belong_to(:user) }
  it { should belong_to(:wiki) }
  it { should validate_presence_of(:user) }
end