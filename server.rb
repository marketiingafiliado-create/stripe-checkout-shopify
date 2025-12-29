require "sinatra"

# Render necesita escuchar en 0.0.0.0 y en el puerto que él asigna
set :bind, "0.0.0.0"
set :port, ENV.fetch("PORT", 4567)

# Servir archivos estáticos desde /public
set :public_folder, File.join(__dir__, "public")
set :static, true

# Health check para Render
get "/healthz" do
  "ok"
end

# Página principal → manda al checkout
get "/" do
  redirect "/checkout.html"
end
