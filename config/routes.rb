Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/member/login", to: "members#login"
      post "/member/logout", to: "members#logout"
      get "/member/find", to: "members#find"

      get "/card/validate", to: "fly_buys_cards#validate"
      put "/card/update_balance", to: "fly_buys_cards#update_balance"
      get "/card/get_balance", to: "fly_buys_cards#get_balance"
    end
  end
end
