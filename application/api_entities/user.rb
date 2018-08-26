class Api
  module Entities
    class UserEntity < UserParamsEntity
      unexpose :password
    end
  end
end
