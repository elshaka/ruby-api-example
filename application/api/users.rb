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
      user_form = Forms::User.new(params[:user]).validate

      if user_form.success?
        user = Models::User.create user_form.to_hash
        present :user, user, with: Entities::User
      else
        error!({errors: user_form.errors}, 400)
      end
    end
  end
end
