def real_mode?
  File.basename($0) != 'rake' &&
      (Rails.env.production? || Rails.env.demo?)
end
