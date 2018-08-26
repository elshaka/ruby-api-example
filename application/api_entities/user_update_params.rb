class Api
  module Entities
    class UserUpdateParams < UserParams
      unexpose :email
      unexpose :password
    end
  end
end
