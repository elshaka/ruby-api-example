class Api
  module Entities
    class User < UserParams
      unexpose :password
    end
  end
end
