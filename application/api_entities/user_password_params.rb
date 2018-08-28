class Api
  module Entities
    class UserPasswordParams < Grape::Entity
      expose :password, documentation: {type: 'String', desc: 'Password', required: true}
      expose :password_confirmation, documentation: {type: 'String', desc: 'Password confirmation', required: true}
    end
  end
end
