require 'jwt'

class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        token = request.env['HTTP_AUTHORIZATION'].scan(/^Bearer (.+)$/).flatten.first
        payload = decode_token token

        @current_user = Api::Models::User.with_pk! payload["id"]
      rescue
        error!({}, 401)
      end

      def current_user
        @current_user
      end

      def issue_token user
        payload = {id: user.id}
        JWT.encode payload, TOKEN_SECRET, 'HS256'
      end

      def decode_token token
        JWT.decode(token, TOKEN_SECRET, 'HS256').first
      end
    end
  end
end
