#require 'stripe-mock'
require 'rails_helper'

include Devise::TestHelpers

describe ChargesController do
  before do
    @user = create(:user)
    sign_in @user
    @amount = create(:amount)
  end
    describe '#new action' do
      it 'renders a new template' do
        get :new
        expect(response).to render_template('new')
      end
    end
    describe '#create' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after { StripeMock.stop }
      it 'creates message on successful payment' do
        customer = Stripe::Customer.create({
          email: @user.email,
          card: stripe_helper.generate_card_token
        })
        expect(customer.email).to eq(@user.email)
      end
    end
end