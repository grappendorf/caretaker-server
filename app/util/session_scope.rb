class SessionScope < Hash

  def initialize
    @sessions = {}
  end

  def session session_id
    @sessions[session_id] ||= {}
  end

  def [] key
    session(session[:session_id])[key]
  end

  def []= key, value
    session(session[:session_id])[key] = value
  end

  def clear_session session_id
    @sessions.delete session_id
  end

  def clear
    @sessions.clear
  end

  def to_s
    @sessions.to_s
  end

  def inspect
    @sessions.inspect
  end

end

::MICON.activate :session, SessionScope.new
