class Api
  resource :users do
    desc 'Returns all users'
    params do
      includes :basic_search
    end
    get do
      users = Models::User.all
      present :users, users, with: Entities::User
    end

    desc 'Creates a user'
    params do
      requires :user, type: Entities::UserParams
    end
    post do
      validation = Validators::User.new(params[:user]).validate

      if validation.success?
        user = Models::User.create params[:user]
        present :user, user, with: Entities::User
      else
        error!({errors: validation.errors}, 400)
      end
    end
  end
end
