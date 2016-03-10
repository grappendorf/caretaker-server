ActiveRecord::Base.module_eval do
  def self.included(base)
    base.extend Rolify
  end
end

Rolify.configure do |_config|
end
