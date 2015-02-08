def real_mode?
  Rails.env.production? || Rails.env.demo?
end
