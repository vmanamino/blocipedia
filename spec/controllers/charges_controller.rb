require 'rails_helper'

include Devise::TestHelpers

describe ChargesController do
  before do
    @user = create(:user)
    sign_in @user
  end
  describe '#new action' do
    before { get :new }
    it { should render_template('new') }
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
      expect(@user.role).to eq('standard')
      post :create
      @user.reload
      expect(@user.role).to eq('premium')
    end
    it 'charges standard user 200 pennies' do
      post :create
      charge = assigns(:charge)
      expect(charge.amount).to eq(200)
    end
    it 'successfully charges standard user\'s account' do
      post :create
      charge = assigns(:charge)
      expect(charge.status).to eq('succeeded')
    end
    it 'keeps premium user\'s role at premium on additional payment' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      user.reload
      expect(user.role).to eq('premium')
    end
    it 'charges a premium user 200 pennies' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      charge = assigns(:charge)
      expect(charge.amount).to eq(200)
    end
    it 'successfully charges premium user\'s account' do
      user = create(:user, role: 'premium')
      sign_in user
      post :create
      charge = assigns(:charge)
      expect(charge.status).to eq('succeeded')
    end
    before { post :create }
    it { should redirect_to(root_path)}
  end
end
