require 'rails_helper'

RSpec.describe Api::V1::FlyBuysCardsController, type: :request do
  let(:member_password) { Faker::AquaTeenHungerForce.character }

  let!(:fly_buys_card) do
    FactoryBot.create(
      :fly_buys_card,
      member: FactoryBot.create(:member, password: member_password)
    )
  end
  let!(:member) { fly_buys_card.member }

  let(:private_api_key) { FactoryBot.create(:private_api_key) }

  let(:valid_card_number_or_email) do
    # API can be queried with either
    [fly_buys_card.number, member.email].sample
  end

  let(:invalid_card_number_or_email) do
    ["1234", "nothing@bademail"].sample
  end

  let(:nonexistant_card_number_or_email) do
    ["6014-1111-2222-3333", Faker::Internet.email].sample
  end

  describe "GET validate" do

  end

  describe "GET get_balance" do
    context "member logged in" do
      before do
        post(api_v1_member_login_path, params: request_params.merge(password: member_password))
        get(api_v1_card_get_balance_path, params: request_params)
      end

      context "correct private API key" do
        let(:parent_request_params) do
          { private_api_key: private_api_key.value }
        end

        context "valid card number or email" do
          let(:request_params) { parent_request_params.merge(card_number_or_email: valid_card_number_or_email) }

          it "is 200 OK" do
            expect(response.status).to eq(200)
          end

          it "correctly returns the balance" do
            expect(json[:balance]).to eq(fly_buys_card.balance)
          end
        end

        context "invalid card number or email" do
          let(:request_params) { parent_request_params.merge(card_number_or_email: invalid_card_number_or_email) }

          it "is 422 unprocessable entity" do
            expect(response.status).to eq(422)
          end

          it "includes the correct error message in the response json" do
            expect(json[:message]).to eq(I18n.t("member.card_or_email.incorrect"))
          end

          it "does not return any card balance" do
            expect(json.keys).not_to include(:balance)
          end
        end

        context "non-existant card number or email" do
          let(:request_params) { parent_request_params.merge(card_number_or_email: nonexistant_card_number_or_email) }

          it "is 404 not found" do
            expect(response.status).to eq(404)
          end

          it "includes the correct error message in the response json" do
            expect(json[:message]).to eq(I18n.t("member.card_or_email.does_not_exist"))
          end

          it "does not return any card balance" do
            expect(json.keys).not_to include(:balance)
          end
        end
      end

      context "invalid private API key" do
        let(:request_params) do
          { private_api_key: "1111-2222-3333-4444" }
        end

        it "is 401 unauthorized" do
          expect(response.status).to eq(401)
        end

        it "includes the correct error message in the response json" do
          expect(json[:message]).to eq(I18n.t("private_api_key.unauthorised"))
        end

        it "does not return any card balance" do
          expect(json.keys).not_to include(:balance)
        end
      end
    end

    context "member not logged in / Session expired" do
      before do
        get(api_v1_card_get_balance_path, params: request_params)
      end

      let(:request_params) do
        {
          private_api_key: private_api_key.value,
          card_number_or_email: valid_card_number_or_email
        }
      end

      it "is 401 unauthorized" do
        expect(response.status).to eq(401)
      end

      it "includes the correct error message in the response json" do
        expect(json[:message]).to eq(I18n.t("member.unauthorised.session_expired"))
      end
    end
  end

  describe "PUT update_balance" do
    let(:updated_balance) { Faker::Number.number(2).to_i }

    let(:request_params) do
      {
        private_api_key: private_api_key.value,
        card_number_or_email: valid_card_number_or_email,
        updated_balance: updated_balance
      }
    end

    context "member logged in " do
      before do
        post(api_v1_member_login_path, params: request_params.merge(password: member_password))
        put(api_v1_card_update_balance_path, params: request_params)
      end

      it "is 200 ok" do
        expect(response.status).to eq(200)
      end

      it "includes the udpated balance in the response json" do
        expect(json.keys).to include("balance")
      end

      it "correctly updates the card balance" do
        expect(fly_buys_card.reload.balance).to eq(updated_balance)
      end
    end

    context "member not logged in / Session expired" do
      before do
        put(api_v1_card_update_balance_path, params: request_params)
      end

      it "is 401 unauthorized" do
        expect(response.status).to eq(401)
      end

      it "includes the correct error message in the response json" do
        expect(json[:message]).to eq(I18n.t("member.unauthorised.session_expired"))
      end
    end
  end

  describe "GET validate" do
    context "member logged in" do
      before do
        post(api_v1_member_login_path, params: request_params.merge(password: member_password))
        get(api_v1_card_validate_path, params: request_params)
      end

      # DRY up this example a bit
      %w[valid invalid].each do |context_type|
        context "#{context_type} format" do
          let(:request_params) do
            {
              private_api_key: private_api_key.value,
              card_number: context_type === "valid" ? fly_buys_card.number : "1234-123-12-1"
            }
          end

          it "is 200 ok" do
            expect(response.status).to eq(200)
          end

          it "displays the correct message in the response json" do
            expect(json[:message]).to eq(I18n.t("fly_buys_card.format.#{context_type}"))
          end
        end
      end
    end
  end
end
