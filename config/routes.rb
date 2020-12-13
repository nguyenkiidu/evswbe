Rails.application.routes.draw do
  get '/' => 'checkout#index'
  get '/checkout-session' => 'checkout#checkout_session'
  post '/create-checkout-session' => 'checkout#create_checkout_session'
  post '/upgrade' => 'checkout#upgrade'
  post '/cancellation-request' => 'checkout#cancellation_request'
  post '/uploads' => 'uploads#create'
end
