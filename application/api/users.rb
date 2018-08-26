class Api
  resource :users do
    params do
      includes :basic_search
    end
    get do
      users = Models::User.all
      present :users, users, with: Entities::UserEntity
    end
  end
end
