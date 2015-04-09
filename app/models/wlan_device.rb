module WlanDevice

  include WlanConnectionState

  inject :wlan_master

  def address16= address16
    @address16 = address16
  end

  def address_to_a
    address.scan(/../).map(&:hex)
  end

  def send_message msg, *params
    wlan_master.send_message address, msg, params
  end

  def reset
    super
    send_message CaretakerMessages::RESET
  end

  def message_received message, params
    if message == CaretakerMessages::PING
      on_ping
    end
  end

  def update_attributes_from_registration params
  end

end
