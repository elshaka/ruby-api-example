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

    desc 'Updates a user'
    params do
      requires :user, type: Entities::UserUpdateParams
    end
    put '/:id' do
      authenticate!

      user = Models::User.find(id: params[:id])
      error!({}, 404) unless user

      user_update_form = Forms::UserUpdate.new(params[:user]).validate

      if user_update_form.success?
        error!({}, 403) unless current_user.can? :edit, user

        user.update user_update_form.to_hash
        present :user, user, with: Entities::User
      else
        error!({errors: user_form.errors}, 400)
      end
    end
  end
end
