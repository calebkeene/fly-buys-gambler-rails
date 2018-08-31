class Api::V1::MembersController < ApplicationController
    include ActionController::Cookies

    before_action :validate_private_api_key
    before_action :set_member

    def login
      # if valid, return a success and set cookie on response
      return json_response({ message: I18n.t("member.login.already_logged_in") }) if member_logged_in?
      raise UnauthorisedError, I18n.t("member.login.incorrect_password") unless correct_password?

      cookies.signed[:logged_in_member_email] = {
        value: member.email,
        expires: 30.minutes
      }
      json_response({ message: I18n.t("member.login.success") })
    end

    def exists
      json_response({ message: I18n.t("member.card_or_email.exists") })
    end

    private

    attr_reader :member

    def set_member
      #binding.pry
      @member = find_member
    end

    def correct_password?
      # check passed in password against encrypted one with salt
      params[:password].present? && Member.valid_password?(member, params[:password])
    end

    def member_logged_in?
      member&.email == cookies.signed["logged_in_member_email"]
    end
end
