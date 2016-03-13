require 'api/widgets'

class API::Dashboards < Base

  resource :dashboards do

    desc 'Get a list of all dashboards'
    params do
      optional :q, type: String, desc: 'Optional query string'
    end
    get do
      authorize! :read, Dashboard
      Dashboard.search(params[:q]).accessible_by(current_ability).map do |dashboard|
        {
          id: dashboard.id,
          name: dashboard.name,
          default: dashboard.default,
          user: {
            id: dashboard.user.id,
            name: dashboard.user.name
          }
        }
      end
    end

    desc 'Get the number of all dashboards'
    get 'count' do
      authorize! :read, Dashboard
      {
        count: Dashboard.accessible_by(current_ability).count
      }
    end

    desc 'Get the names of all dashboards'
    get 'names' do
      Dashboard.accessible_by(current_ability).select(:id, :name, :default).each do |dashboard|
        {
          id: dashboard.id,
          name: dashboard.name,
          default: dashboard.default
        }
      end
    end

    desc 'Get a new dashboard'
    get 'new' do
      authorize! :read, Dashboard
      dashboard_to_json Dashboard.new user: current_user
    end

    desc 'Get the default dashboard'
    get 'default' do
      if current_user && current_user.dashboards.default
        {
          id: current_user.dashboards.default.id
        }
      else
        body false
      end
    end

    desc 'Get a specific dashboard'
    get ':id' do
      dashboard = Dashboard.find params[:id]
      authorize! :read, dashboard
      dashboard_to_json dashboard
    end

    desc 'Create a new dashboard'
    params do
      requires :name, type: String, desc: 'The name of the new dashboard'
      optional :default, type: Boolean, desc: 'If true this is the default dashboard'
      optional :user_id, type: Integer, desc: 'The id of the user who owns the dashboard'
    end
    post do
      authorize! :create, Dashboard
      user = User.find_by_id(params[:user_id]) || current_user
      dashboard = Dashboard.create! permitted_params.merge({
        user: user,
        default: user.dashboards.empty?
      })
      {
        id: dashboard.id
      }
    end

    desc 'Update a dashboard'
    params do
      optional :name, type: String, desc: 'The name of the new dashboard'
      optional :default, type: Boolean, desc: 'If true this is the default dashboard'
    end
    put ':id' do
      dashboard = Dashboard.find params[:id]
      authorize! :update, dashboard
      dashboard.update_attributes! permitted_params
      body false
    end

    desc 'Delete a dashboard'
    delete ':id' do
      dashboard = Dashboard.find(params[:id])
      authorize! :destroy, dashboard
      dashboard.destroy
      body false
    end
  end

  helpers do
    include API::Widgets::JSONHelpers

    def dashboard_to_json dashboard
      {
        id: dashboard.persisted? ? dashboard.id : nil,
        name: dashboard.name,
        default: dashboard.default,
        user: {
          id: dashboard.user.id,
          name: dashboard.user.name
        },
        widgets: dashboard.widgets.map(&:specific).map do |w|
          send "#{w.class.name.underscore}_to_json", w
        end
      }
    end
  end
end
