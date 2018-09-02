# README

Simulation of fly-buys API for validating card numbers, getting/updating member balances, and custom member authentication.

## Endpoints

All requests must include the `private_api_key` parameter, and an additional parameter `card_number_or_email`, which is either the fly buys card number, or the email of a member. When calling the `login` endpoint, `password` must also be supplied.

- POST `/api/v1/member/login`
- GET `/api/v1/member/exists`
- GET `/api/v1/member/find`
- GET `/api/v1/card/validate`
- GET `/api/v1/card/get_balance`
- PUT `/api/v1/card/update_balance`

## Getting it working

- `bundle`
- `bundle exec rake db:{create, migrate, seed}`
- `bundle exec rails s -p 5000`

Note: I was going to be fancy and build my own user-auth in some interesting way, but I ended up being short on time and just using signed cookies. Still need to get this working properly with the React front-end, which uses the `fetch` API to make the HTTP requests, and isn't currently setting the cookie in the request header. To make the server work, uncomment line 31 of `fly_buys_cards_controller.rb` (currently the cookie value needs to be set properly, otherwise it'll return 401)
