class Api::V1::FlyBuysCardsController < ApplicationController
  include ActionController::Cookies

  before_action :validate_private_api_key
  before_action :set_member, except: :validate
  before_action :set_fly_buys_card, except: :validate

  def validate
    response_type =  params[:fly_buys_card_number] =~ FlyBuysCard::VALID_FORMAT ? "valid" : "invalid"
    json_response({ message: I18n.t("fly_buys_card.format.#{response_type}") })
  end

  def get_balance
    respond_with_balance
  end

  def update_balance
    raise MalformattedRequestError, I18n.t("fly_buys_card.balance.update") unless params[:number_points].present?

    fly_buys_card.balance = fly_buys_card.balance + params[:number_points].to_i
    fly_buys_card.save!
    respond_with_balance
  end

  private

  attr_reader :member, :fly_buys_card

  def set_member
    @member = find_member
    # member needs to be authed at this point - email cookie set
    if member&.email != cookies["signed_in_member_email"]
      raise UnauthorisedError, I18n.t("member.unauthorised.session_expired")
    end
  end

  def set_fly_buys_card
    @fly_buys_card = member.fly_buys_card
  end

  def respond_with_balance
    json_response({ balance: fly_buys_card.balance })
  end
end
