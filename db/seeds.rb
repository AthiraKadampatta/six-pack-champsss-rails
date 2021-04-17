# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
roles = ['owner', 'admin', 'associate']

roles.each do |role|
  Role.create(name: role)
end

users = [{ name: 'Athira', email: 'athira@kiprosh.com', role_id: 2 },
         { name: 'Prayesh', email: 'prayesh@kiprosh.com', role_id: 1},
         { name: 'Supriya', email: 'supriya.medankar@kiprosh.com', role_id: 3}]

users.each do |user|
  User.create(user)
end