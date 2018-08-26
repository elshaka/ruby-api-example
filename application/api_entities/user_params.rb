class Api
  module Entities
    class UserParamsEntity < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt && dt.strftime("%Y-%m-%d") }

      expose :first_name, documentation: {type: 'String', desc: 'User first name', required: true}
      expose :last_name, documentation: {type: 'String', desc: 'User last name', required: true}
      expose :email, documentation: {type: 'String', desc: 'User email', required: true}
      expose :password, documentation: {type: 'String', dec: 'User password', required: true}

      with_options(format_with: :iso_timestamp) do
        expose :born_on, documentation: {type: 'String', dec: 'User date of birth', required: false}
      end
    end
  end
end
