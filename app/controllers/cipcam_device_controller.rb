class CipcamDeviceController < ApplicationController

  load_and_authorize_resource

  def image
    res = HTTParty.get "http://#{@cipcam_device.address}/snapshot.cgi",
                       basic_auth: {username: @cipcam_device.user, password: @cipcam_device.password}
    send_data res.body, type: res.headers['Content-Type']
  end

end
