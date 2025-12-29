# server.rb
require "sinatra"
require "stripe"
require "json"

# Render necesita que tu app escuche en 0.0.0.0 y en el puerto ENV["PORT"]
set :bind, "0.0.0.0"
set :port, ENV.fetch("PORT", 4567)

# Archivos estáticos (tu /public/checkout.html, /public/style.css, etc.)
set :public_folder, File.join(__dir__, "public")
set :static, true

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

get "/" do
  redirect "/checkout"
end

get "/checkout" do
  send_file File.join(settings.public_folder, "checkout.html")
end

get "/success" do
  send_file File.join(settings.public_folder, "success.html")
end

get "/cancel" do
  send_file File.join(settings.public_folder, "cancel.html")
end

# Endpoint para crear la sesión de Stripe Checkout
post "/create-checkout-session" do
  content_type :json

  body = request.body.read
  data = body && body.size > 0 ? (JSON.parse(body) rescue {}) : {}

  # Default (cámbialo si quieres): $249.00 MXN => 24900 centavos
  amount   = (data["amount"].to_i > 0 ? data["amount"].to_i : 24900)
  currency = (data["currency"] || "mxn").downcase
  name     = data["name"] || "Compra"

  session = Stripe::Checkout::Session.create(
    mode: "payment",
    line_items: [
      {
        quantity: 1,
        price_data: {
          currency: currency,
          unit_amount: amount,
          product_data: { name: name }
        }
      }
    ],
    success_url: "#{request.base_url}/success?session_id={CHECKOUT_SESSION_ID}",
    cancel_url:  "#{request.base_url}/cancel"
  )

  { url: session.url }.to_json
end

# Para health checks (opcional pero útil)
get "/healthz" do
  "ok"
end
