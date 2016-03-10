User.create!(name: 'admin',
  email: 'admin@example.com',
  password: 'admin').tap do |admin|
  admin.add_role :user
  admin.add_role :manager
  admin.add_role :admin
end

User.create!(name: 'manager',
  email: 'manager@example.com',
  password: 'manager').tap do |manager|
  manager.add_role :user
  manager.add_role :manager
end

User.create!(name: 'user',
  email: 'user@example.com',
  password: 'user').tap do |user|
  user.add_role :user
end
