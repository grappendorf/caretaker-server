# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_id   :integer
#  resource_type :string
#

Fabricator :role do
  name 'role'
end

Fabricator :admin_role, from: :role do
  name 'admin'
end

Fabricator :manager_role, from: :role do
  name 'manager'
end

Fabricator :user_role, from: :role do
  name 'user'
end
