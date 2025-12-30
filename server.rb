require "sinatra"
require "stripe"

set :public_folder, File.dirname(__FILE__) + "/public"

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

get "/" do
  send_file File.join(settings.public_folder, "checkout.html")
end

get "/success" do
  send_file File.join(settings.public_folder, "success.html")
end

get "/cancel" do
  send_file File.join(settings.public_folder, "cancel.html")
end

post "/create-checkout-session" do
  session = Stripe::Checkout::Session.create(
    payment_method_types: ["card"],
    mode: "payment",
    line_items: [{
      price_data: {
        currency: "mxn",
        product_data: {
          name: "Producto Shopify"
        },
        unit_amount: 24900
      },
      quantity: 1
    }],
    success_url: "#{request.base_url}/success",
    cancel_url: "#{request.base_url}/cancel"
  )

  redirect session.url, 303
end
