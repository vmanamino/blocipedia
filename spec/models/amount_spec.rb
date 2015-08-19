require 'rails_helper'

describe Amount do
  before do
    @amount = create(:amount)
  end
  it 'produces charge amount' do
    expect(@amount.default).to eq(200)
  end
  it '.default' do
    expect(@amount.amount).to be_nil
  end
  it 'sets amount attribute after calling default' do
    @amount.default
    expect(@amount.amount).to eq(200)
  end
end
