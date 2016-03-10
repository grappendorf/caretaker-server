# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string           default("")
#  encrypted_password :string           default("")
#

Fabricator :admin, from: :user do
  name 'admin'
  email 'admin@example.com'
  password 'password'
  after_build do |admin|
    admin.add_role :admin
    admin.add_role :manager
    admin.add_role :user
  end
end

Fabricator :manager, from: :user do
  name 'manager'
  email 'manager@example.com'
  password 'password'
  after_create do |manager|
    manager.add_role :manager
    manager.add_role :user
  end
end

Fabricator :user do
  name { sequence (:name) { |n| "user#{n > 0 ? n + 1 : nil}" } }
  email { sequence (:email) { |n| "user#{n > 0 ? n + 1 : nil}@example.com" } }
  password 'password'
  after_create do |user|
    user.add_role :user
  end
end

Fabricator :other_user, from: :user do
  name 'roe'
  email 'jane.roe@example.com'
  password 'password'
  after_create do |user|
    user.add_role :user
  end
end

Fabricator :alice, from: :user do
  name 'alice'
  email 'alice@example.com'
  password 'password'
  after_create do |user|
    user.add_role :user
  end
end

Fabricator :bob, from: :user do
  name 'bob'
  email 'bob@example.com'
  password 'password'
  after_create do |user|
    user.add_role :user
  end
end

Fabricator :carol, from: :user do
  name 'carol'
  email 'carol@example.com'
  password 'password'
  after_create do |user|
    user.add_role :user
  end
end
