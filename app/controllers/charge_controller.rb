class ChargeController < ApplicationController
  before_action :authenticate_user!, except: [:notify]

def pay
  booking = Booking.find(params[:booking_id])
  space = Space.find(params[booking.space_id])

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => booking.total_in_cents,
    :description => space.space_name,
    :currency    => 'hkd'
  )

  if charge
    booking.update_attributes payment_status:true
    redirect_to space
  else
    booking.destroy
    redirect_to space
  end

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to space
end
