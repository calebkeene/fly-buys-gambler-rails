class Api::V1::MembersController < ApplicationController
    include ActionController::Cookies

    before_action :validate_private_api_key
    before_action :set_member

    def login
      # if valid, return a success and set cookie on response
      raise UnauthorisedError, I18n.t("member.sign_in.incorrect_password") unless correct_password?

      # TODO: this is insecure: make this a signed cookie that can be decrypted
      # with secret key in front-end, for validated signed-in members (AES-256)
      cookies[:signed_in_member_email] = {
        value: member.email,
        expires: 30.minutes
      }
      json_response({ message: I18n.t("member.sign_in.success") })
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
end
