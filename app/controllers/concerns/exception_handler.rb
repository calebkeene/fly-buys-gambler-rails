module ExceptionHandler
  extend ActiveSupport::Concern

  class UnauthorisedError < StandardError; end
  class MalformattedRequestError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ message: error.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      respond_with_unprocessable_entity(error)
    end

    rescue_from MalformattedRequestError do |error|
      respond_with_unprocessable_entity(error)
    end

    rescue_from UnauthorisedError do |error|
      json_response({ message: error.message }, :unauthorized)
    end
  end

  private

  def respond_with_unprocessable_entity(error)
    json_response({ message: error.message }, :unprocessable_entity)
  end
end
