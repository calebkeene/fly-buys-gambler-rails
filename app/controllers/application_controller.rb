class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def find_member
    raise MalformattedRequestError, I18n.t("member.incorrect_email_or_card_number") if invalid_card_number_or_email?

    member = if finding_by_card_number?
      Member.joins(:fly_buys_card).where("fly_buys_cards.number = (?)", params[:card_number_or_email]).first
    else
      Member.find_by(email: params[:card_number_or_email])
    end

    raise ActiveRecord::RecordNotFound, I18n.t("member.email_or_card_does_not_exist") unless member
    member
  end

  def validate_private_api_key
    # respond with 401 unauthorized if a corresponding API key isn't found
    raise UnauthorisedError, I18n.t("private_api_key.unauthorised") unless private_api_key_valid?
  end

  private

  def invalid_card_number_or_email?
    # really only checking validity of one - only one is passed at a time
    !finding_by_card_number? && !finding_by_email?
  end

  def private_api_key_valid?
    # just validates the existance of a matching key
    !PrivateApiKey.find_by(value: params[:private_api_key]).nil?
  end

  def finding_by_card_number?
    params[:card_number_or_email] =~ FlyBuysCard::VALID_FORMAT
  end

  def finding_by_email?
    params[:card_number_or_email] =~ Member::VALID_EMAIL_FORMAT
  end
end
