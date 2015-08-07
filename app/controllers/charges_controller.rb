class ChargesController < ApplicationController
  def new
    amount = Amount.new
    @stripe_btn_data = {
      key: "#{Rails.configuration.stripe[:publishable_key]}",
      description: "BigMoney Membership - #{current_user.name}",
      amount: amount.default
    }
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    amount = Amount.new
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    charge = Stripe::Charge.create( # rubocop:disable Lint/UselessAssignment
      customer: customer.id,
      amount: amount.default,
      description: "BigMoney membership #{current_user.email}",
      currency: 'usd'
    )
    current_user.update_attributes(role: 'premium')
    flash[:notice] = "Thanks for all the money, #{current_user.email}.  Pay me some more!"
    redirect_to root_path

    # Error handling
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
