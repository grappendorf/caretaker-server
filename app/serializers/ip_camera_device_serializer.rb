class IpCameraDeviceSerializer < DeviceSerializer

	attributes :host, :port, :user, :password, :refresh_interval

end