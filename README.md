# README

Simulation of fly-buys API for validating card numbers, getting/updating member balances, and custom member authentication.

## Endpoints

All requests must include the `private_api_key` parameter, and an additional parameter `card_number_or_email`, which is either the fly buys card number, or the email of a member. When calling the `login` endpoint, `password` must also be supplied.

- POST `/api/v1/login`
- GET `/api/v1/validate`
- GET `/api/v1/get_balance`
- PUT `/api/v1/update_balance`
