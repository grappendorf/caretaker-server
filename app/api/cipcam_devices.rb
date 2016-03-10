class API::CipcamDevices < Base

  resource :cipcam_device do

    get ':id/image' do
      cipcam_device = CipcamDevice.find(params[:id])
      authorize! :read, cipcam_device
      res = HTTParty.get "http://#{cipcam_device.address}/snapshot.cgi",
        basic_auth: {username: cipcam_device.user, password: cipcam_device.password}
      send_data res.body, type: res.headers['Content-Type']
    end
  end
end
