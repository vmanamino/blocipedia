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
    let(:amount) { create(:amount) }
    before { StripeMock.start }
    after { StripeMock.stop }
    it 'creates message on successful payment' do
      post :create
      expect(flash[:notice]).to eq("Thanks for all the money, #{@user.email}.  Pay me some more!")
    end
    it 'upgrades the user\'s role/account to premium' do
      post :create
      customer = Stripe::Customer.create(
        email: @user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create( # rubocop:disable Lint/UselessAssignment
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{@user.email}",
        currency: 'usd'
      )
      my_user = User.find_by(id: @user.id)
      expect(my_user.role).to eq('premium')
    end
    it 'charges standard user 200 pennies' do
      post :create
      customer = Stripe::Customer.create(
        email: @user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{@user.email}",
        currency: 'usd'
      )
      expect(charge.amount).to eq(200)
    end
    it 'successfully charges standard user\'s account' do
      post :create
      customer = Stripe::Customer.create(
        email: @user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{@user.email}",
        currency: 'usd'
      )
      expect(charge.status).to eq('succeeded')
    end
    it 'keeps premium user\'s role at premium on additional payment' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      customer = Stripe::Customer.create(
        email: user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create( # rubocop:disable Lint/UselessAssignment
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{user.email}",
        currency: 'usd'
      )
      my_user = User.find_by(id: user.id)
      expect(my_user.role).to eq('premium')
    end
    it 'charges a premium user 200 pennies' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      customer = Stripe::Customer.create(
        email: user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{user.email}",
        currency: 'usd'
      )
      expect(charge.amount).to eq(200)
    end
    it 'successfully charges premium user\'s account' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      customer = Stripe::Customer.create(
        email: user.email,
        card: stripe_helper.generate_card_token
      )
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: amount.default,
        description: "BigMoney membership #{user.email}",
        currency: 'usd'
      )
      expect(charge.status).to eq('succeeded')
    end
  end
end
