Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/login", to: "members#login"

      get "/validate", to: "fly_buys_cards#validate"
      put "/update_balance", to: "fly_buys_cards#update_balance"
      get "/get_balance", to: "fly_buys_cards#get_balance"
    end
  end
end
