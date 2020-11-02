Rails.application.routes.draw do
  get '/checkout-session' => 'checkout#checkout_session'
  post '/create-checkout-session' => 'checkout#create_checkout_session'  
end
