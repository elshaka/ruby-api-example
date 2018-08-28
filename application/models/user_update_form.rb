class Api
  module Forms
    class UserUpdate
      include Hanami::Validations::Form

      validations do
        required(:first_name) { filled? & str? }
        required(:last_name) { filled? & str? }
      end
    end
  end
end
