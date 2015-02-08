User.create!(name: 'admin',
             email: 'admin@example.com',
             password: 'password',
             password_confirmation: 'password').tap do |admin|
  admin.add_role :user
  admin.add_role :manager
  admin.add_role :admin
end

User.create!(name: 'manager',
             email: 'manager@example.com',
             password: 'password',
             password_confirmation: 'password').tap do |manager|
  manager.add_role :user
  manager.add_role :manager
end

User.create!(name: 'user',
             email: 'user@example.com',
             password: 'password',
             password_confirmation: 'password').tap do |user|
  user.add_role :user
end
