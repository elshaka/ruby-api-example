class Api
  module Entities
    class User < UserParams
      expose :id, documentation: {type: 'Integer', desc: 'User id'}
      unexpose :password
    end
  end
end
