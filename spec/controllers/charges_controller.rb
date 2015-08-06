#require 'stripe-mock'
require 'rails_helper'

include Devise::TestHelpers

describe ChargesController do
  before do
    @user = create(:user)
    sign_in @user
  end
    describe '#new action' do
      it 'renders a new template' do
        get :new
        expect(response).to render_template('new')
      end
    end
    describe '#create' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      let(:user) { create(:user) }
      let(:amount) { create(:amount) }
      before { StripeMock.start }
      after { StripeMock.stop }
      it 'creates message on successful payment' do
        post :create
        expect(flash[:notice]).to eq("Thanks for all the money, #{@user.email}.  Pay me some more!")
      end
      it 'upgrades the user\'s role/account to premium' do
#         user = create(:user, role: 'standard')
#         sign_in user
        youser = @user
        post :create
        customer = Stripe::Customer.create({
          email: youser.email,
          card: stripe_helper.generate_card_token
        })
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: amount.default,
          description: "BigMoney membership #{youser.email}",
          currency: 'usd'
        )
        expect(youser.role).to eq('premium')
      end
    end
end