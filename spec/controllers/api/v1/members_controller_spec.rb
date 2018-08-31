require 'rails_helper'

RSpec.describe Api::V1::MembersController, type: :request do
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
    ["6014-1111-2222-2222", Faker::Internet.email].sample
  end

  describe "POST /member/login" do
    before { post(api_v1_member_login_path, params: request_params) }

    context "correct private API key used" do
      context "valid_card_number_or_email" do
        context "correct password" do
          let(:request_params) do
            {
              private_api_key: private_api_key.value,
              card_number_or_email: valid_card_number_or_email,
              password: member_password
            }
          end

          context "member not already logged in" do
            it "is 200 ok" do
              expect(response.status).to eq(200)
            end

            it "includes a success message in the response json" do
              expect(json[:message]).to eq(I18n.t("member.login.success"))
            end

            it "sets the user login cookie in the response" do
              expect(response.cookies.keys).to include("logged_in_member_email")
              expect(response.cookies["logged_in_member_email"]).not_to be_nil
            end
          end

          context "member already logged in" do
            before do
              2.times do
                post(api_v1_member_login_path, params: request_params)
              end
            end

            it "is 200 ok" do
              expect(response.status).to eq(200)
            end

            it "includes the correct message in the json response" do
              expect(json[:message]).to eq(I18n.t("member.login.already_logged_in"))
            end
          end
        end

        context "incorrect password" do
          let(:request_params) do
            {
              private_api_key: private_api_key.value,
              card_number_or_email: valid_card_number_or_email,
              password: Faker::Crypto.md5 # random hash
            }
          end

          it "is 401 unauthorized" do
            expect(response.status).to eq(401)
          end

          it "includes the correct error message in the response json" do
            expect(json[:message]).to eq(I18n.t("member.login.incorrect_password"))
          end

          it "does not set the user login cookie in the response" do
            expect(response.cookies.keys).not_to include("logged_in_member_email")
            expect(response.cookies["logged_in_member_email"]).to be_nil
          end
        end
      end
    end

    context "incorrect private API key used" do
      let(:request_params) do
        { private_api_key: "1111-2222-3333-4444", password: member_password }
      end
      before { post(api_v1_member_login_path, params: request_params) }

      it "is 401 unauthorized" do
        expect(response.status).to eq(401)
      end

      it "includes the correct error message in the response json" do
        expect(json[:message]).to eq(I18n.t("private_api_key.unauthorised"))
      end

      it "does not set a cookie in the response" do
        expect(response.cookies.keys).not_to include("logged_in_member_email")
        expect(response.cookies["logged_in_member_email"]).to be_nil
      end
    end
  end

  describe "GET /member/exists" do
    let(:parent_request_params) do
      { private_api_key: private_api_key.value }
    end
    before { get(api_v1_member_exists_path, params: request_params) }

    context "member exists (can be found with card_number or email)" do
      let(:request_params) do
        parent_request_params.merge(card_number_or_email: valid_card_number_or_email)
      end

      it "is 200 ok" do
        expect(response.status).to eq(200)
      end

      it "includes the correct success message in the response json" do
        expect(json[:message]).to eq(I18n.t("member.card_or_email.exists"))
      end
    end

    context "member does not exist (cannot be found with card number or email)" do
      let(:request_params) do
        parent_request_params.merge(card_number_or_email: nonexistant_card_number_or_email)
      end

      it "is 404 not found" do
        expect(response.status).to eq(404)
      end

      it "includes the correct error message in the response json" do
        expect(json[:message]).to eq(I18n.t("member.card_or_email.does_not_exist"))
      end
    end
  end
end
