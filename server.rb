require 'stripe'
require 'sinatra'
require 'json'

set :static, true

# =====================
# CONFIG (ENV VARS)
# =====================
# IMPORTANT: No pongas tu Secret Key en el código.
Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')

PRICE_ID    = ENV.fetch('STRIPE_PRICE_ID') # ej: price_123
APP_DOMAIN  = ENV.fetch('APP_DOMAIN')      # ej: https://tu-app.onrender.com

SUCCESS_URL = ENV.fetch('SUCCESS_URL', "#{APP_DOMAIN}/success.html")
CANCEL_URL  = ENV.fetch('CANCEL_URL',  "#{APP_DOMAIN}/cancel.html")

helpers do
  def safe_int(val, default = 1)
    n = val.to_i
    return default if n < 1
    return 10 if n > 10
    n
  end
end

# ---------------------
# GET /pay (ideal para Shopify)
# ---------------------
# Ejemplo:
#   https://tu-app.onrender.com/pay?qty=1&shop=...&product=...&variant=...
get '/pay' do
  qty = safe_int(params['qty'] || '1', 1)

  session = Stripe::Checkout::Session.create(
    mode: 'payment',
    line_items: [{ price: PRICE_ID, quantity: qty }],
    success_url: "#{SUCCESS_URL}?session_id={CHECKOUT_SESSION_ID}",
    cancel_url:  CANCEL_URL,
    metadata: {
      source:  'shopify',
      shop:    (params['shop'] || ''),
      product: (params['product'] || ''),
      variant: (params['variant'] || '')
    }
  )

  redirect session.url, 303
end

# ---------------------
# POST /create-checkout-session (se mantiene por compatibilidad)
# ---------------------
post '/create-checkout-session' do
  content_type 'application/json'

  qty = safe_int(params['qty'] || '1', 1)

  session = Stripe::Checkout::Session.create(
    mode: 'payment',
    line_items: [{ price: PRICE_ID, quantity: qty }],
    success_url: "#{SUCCESS_URL}?session_id={CHECKOUT_SESSION_ID}",
    cancel_url:  CANCEL_URL
  )

  { url: session.url }.to_json
end
