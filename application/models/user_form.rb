class Api
  module Forms
    class User
      include Hanami::Validations

      validations do
        required("first_name") { filled? & str? }
        required("last_name") { filled? & str? }
        required("password") { filled? & str? & size?(8..100) }
        required("email")  { filled? & str? }
      end
    end
  end
end
