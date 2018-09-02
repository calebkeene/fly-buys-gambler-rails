class Api::V1::MembersController < ApplicationController
    before_action :validate_private_api_key
    before_action :set_member

    def login
      # if valid, return a success and set cookie on response
      return json_response({ message: I18n.t("member.login.already_logged_in") }) if member_logged_in?
      raise UnauthorisedError, I18n.t("member.login.incorrect_password") unless correct_password?

      # this is obviously a very insecure way to do login!
      # only did this approach for simplicity / proof of concept
      cookies.signed[:logged_in_member_email] = {
        value: member.email,
        expires: 20.minutes
      }

      json_response({
        message: I18n.t("member.login.success"),
        email: member.email,
        name: member.name,
        fly_buys_balance: member.fly_buys_card.balance
      })
    end

    def logout
      cookies[:logged_in_member_email] = nil
      json_response({ message: I18n.t("member.logout.success") })
    end

    def find
      json_response({ message: I18n.t("member.card_or_email.exists") })
    end

    private

    attr_reader :member

    def set_member
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
