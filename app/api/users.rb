class API::Users < Base

  resource :users do

    desc 'Get a list of all users'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, User
      User.search(params[:q]).accessible_by(current_ability).map do |user|
        {
          id: user.id,
          email: user.email,
          name: user.name,
          roles: user.roles.map(&:name),
        }
      end
    end

    desc 'Get the number of all users'
    get 'count' do
      authorize! :read, User
      {
        count: User.accessible_by(current_ability).count
      }
    end

    desc 'Get a new user'
    get 'new' do
      authorize! :read, User
      user_to_json User.new
    end

    desc 'Get a specific user'
    get ':id' do
      user = User.find params[:id]
      authorize! :read, user
      user_to_json user
    end

    desc 'Create a new user'
    params do
      requires :email, type: String
      requires :password, type: String
      requires :name, type: String
      optional :roles, type: Array
    end
    post do
      authorize! :create, User
      user = User.create! permitted_params.except :roles
      add_user_roles user, params[:roles]
      {
        id: user.id
      }
    end

    desc 'Update a user'
    params do
      requires :email, type: String
      requires :name, type: String
      optional :password, type: String
      optional :roles, type: Array
    end
    put ':id' do
      user = User.find params[:id]
      authorize! :update, user
      user.update_attributes! permitted_params.except :roles
      add_user_roles user, params[:roles]
      body false
    end

    desc 'Delete a user'
    delete ':id' do
      user = User.find(params[:id])
      authorize! :destroy, user
      user.destroy
      body false
    end
  end

  helpers do
    def user_to_json user
      {
        id: user.persisted? ? user.id : nil,
        email: user.email,
        name: user.name,
        roles: user.roles.map(&:name)
      }
    end

    def add_user_roles user, roles
      if roles
        user.roles = []
        roles.each { |role| user.add_role role }
      end
    end
  end
end
