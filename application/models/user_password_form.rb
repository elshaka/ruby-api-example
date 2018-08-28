class Api
  module Forms
    class UserPassword
      include Hanami::Validations::Form

      validations do
        required(:password).filled(:str?, size?: (8..100)).confirmation
      end
    end
  end
end
