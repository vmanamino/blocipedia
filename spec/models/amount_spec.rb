require 'rails_helper'

describe Amount do
  it 'produces charge amount' do
    amount = Amount.new
    expect(amount.default).to eq(200)
  end
end