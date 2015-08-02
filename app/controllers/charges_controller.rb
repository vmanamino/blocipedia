class ChargesController < ApplicationController
  def new
    amount = Amount.new
    @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "BigMoney Membership - #{current_user.name}",
    amount: amount.default
   }
  end
  
  def create
    amount = Amount.new
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: amount.default,
      description: "BigMoney membership #{current_user.email}",
      currency: 'usd'
      )
    user = current_user
    user.role = 'premium'
    user.save
    flash[:success] = 'Thanks for all the money, #{current_user.email}.  Pay me some more!'
    redirect_to root_path
    
    # Error handling
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
