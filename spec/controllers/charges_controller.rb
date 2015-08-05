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
      let(:user) { create(:user) }
      before { StripeMock.start }
      after { StripeMock.stop }
      it 'creates message on successful payment' do
        post :create
        customer = Stripe::Customer.create({
          email: @user.email,
          card: stripe_helper.generate_card_token
        })
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: @amount.default,
          description: "BigMoney membership #{@user.email}",
          currency: 'usd'
        )
        expect(flash[:notice]).to eq("Thanks for all the money, #{@user.email}.  Pay me some more!")
      end
      it 'upgrades the user\'s role/account to premium' do
        user = create(:user)
        post :create
        customer = Stripe::Customer.create({
          email: user.email,
          card: stripe_helper.generate_card_token
        })
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: @amount.default,
          description: "BigMoney membership #{user.email}",
          currency: 'usd'
        )
        role = user.role
        expect(role).to eq('premium')
      end
    end
end