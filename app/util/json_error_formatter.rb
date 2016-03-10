module JsonErrorFormatter
  def self.call message, backtrace, options = {}, env = nil
    message = ::Grape::ErrorFormatter::Base.present message, env
    result = message.is_a?(String) ? { error: { message: message } } : message

    if (options[:rescue_options] || {})[:backtrace] && backtrace && !backtrace.empty?
      result = result.merge(backtrace: backtrace)
    end
    MultiJson.dump(result)
  end
end
