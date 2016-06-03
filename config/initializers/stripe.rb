Rails.configuration.stripe = {
  :publishable_key => ENV['P_KEY'],
  :secret_key      => ENV['S_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
