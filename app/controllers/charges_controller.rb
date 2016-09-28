class ChargesController < ApplicationController
  def new
    @cart = current_cart
    @amount = @cart.products.sum(:price)
  end

  def create
    # Amount in cents
    @cart = current_cart
    @amount = @cart.products.sum(:price)

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end
  end
