json.id @user.id
json.email @user.email
json.name @user.name
json.roles @user.roles.map(&:name)
