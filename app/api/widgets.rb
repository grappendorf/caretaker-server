require 'api/devices'

class API::Widgets < Base

  helpers do
    params :widgets do
      optional :title, type: String, desc: 'Widget title'
      optional :width, type: Integer, desc: 'Horizontal widget size'
      optional :height, type: Integer, desc: 'Vertical widget size'
      optional :position, type: Integer, desc: 'Linear ordering of the widgets'
    end

    params :action_widgets do
      create = ! declared_param?(:id)
      optional :device_action_id, presence: create, type: Integer, desc: 'The id of displayed device action'
    end

    params :clock_widgets do
    end

    params :device_widgets do
      create = ! declared_param?(:id)
      optional :device_id, presence: create, type: Integer, desc: 'The id of displayed device'
    end

    params :weather_widgets do
      create = ! declared_param?(:id)
      optional :api_key, presence: create, type: String, desc: 'The weather REST API key'
    end
  end

  namespace 'dashboards/:dashboard_id' do

    Widget.models_paths.each do |widget_path|
      resource widget_path.to_sym do

        desc 'Get a new widget'
        get 'new' do
          authorize! :read, Widget
          widget = Widget.new_from_type widget_path
          send "#{widget.class.name.underscore}_to_json", widget
        end

        desc 'Create a new widget'
        params do
          use :widgets
          use widget_path.to_sym
        end
        post do
          authorize! :create, Widget
          dashboard = Dashboard.find params[:dashboard_id]
          authorize! :update, dashboard
          widget = Widget.new_from_type widget_path
          widget.update_attributes! permitted_params.merge({
            dashboard: dashboard
          })
          {
            id: widget.id
          }
        end

        desc 'Update a widget'
        params do
          requires :id, type: String, desc: 'The id of the widget to update'
          use :widgets
          use widget_path.to_sym
        end
        put ':id' do
          authorize! :update, Dashboard.find(params[:dashboard_id])
          widget = Widget.find(params[:id]).specific
          authorize! :update, widget
          widget.update_attributes! permitted_params.compact
          body false
        end
      end
    end

    resource :widgets do

      desc 'Get the number of all widget'
      get 'count' do
        dashboard = Dashboard.find params[:dashboard_id]
        authorize! :read, dashboard
        {
          count: dashboard.widgets.count
        }
      end

      desc 'Get a list of all widgets'
      get do
        dashboard = Dashboard.find params[:dashboard_id]
        authorize! :read, dashboard
        dashboard.widgets.map(&:specific).map do |widget|
          send "#{widget.class.name.underscore}_to_json", widget
        end
      end

      desc 'Get a specific widget'
      get ':id' do
        widget = Widget.find(params[:id]).specific
        authorize! :read, widget
        send "#{widget.class.name.underscore}_to_json", widget
      end

      desc 'Delete a widget'
      delete ':id' do
        authorize! :update, Dashboard.find(params[:dashboard_id])
        widget = Widget.find params[:id]
        authorize! :destroy, widget
        widget.destroy
        body false
      end
    end
  end

  module JSONHelpers
    include API::Devices::JSONHelpers

    def widget_to_json widget
      {
        id: widget.persisted? ? widget.acting_as.id : nil,
        type: widget.type,
        title: widget.title,
        position: widget.position,
        width: widget.width,
        height: widget.height
      }
    end

    def action_widget_to_json widget
      {
        action: {
          id: widget.device_action.id,
          name: widget.device_action.name
        }
      }.merge(widget_to_json widget)
    end

    def clock_widget_to_json widget
      {
      }.merge(widget_to_json widget)
    end

    def device_widget_to_json widget
      device = widget.device.specific
      {
        device: send("#{device.class.name.underscore}_to_json", device)
      }.merge(widget_to_json widget)
    end

    def weather_widget_to_json widget
      {
        api_key: widget.api_key
      }.merge(widget_to_json widget)
    end
  end

  helpers do
    include JSONHelpers
  end
end
