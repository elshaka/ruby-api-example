class Api
  module Forms
    class UserPassword
      include Hanami::Validations

      validations do
        # required("password").filled(:str?, size?: (8..100)).confirmation
        required("password") { filled? & str? & size?(8..100) }
        required("password_confirmation") { filled? & str? & size?(8..100) }
        rule(password_match: ["password", "password_confirmation"]) do |password, password_confirmation|
          password.eql?(password_confirmation)
        end
      end
    end
  end
end
