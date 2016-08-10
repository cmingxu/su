# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

User.new(email: "cming.xu@gmail.com", password: "cming.xu@gmail.com", roles: ["admin"]).save
owner = User.new(email: "siteowner@siteowner.com", password: "siteowner@siteowner", roles: ["siteowner", "user"])
owner.save
User.new(email: "user@user.com", password: "user@user", roles: ["user"]).save

%w(门窗 衣橱 厨房 卫生间 卧室 沙发 电视柜).each do |f|
  Folder.create name: f, user_id: owner.id
end 



100.times do
  Entity.create do |e|
    e.folder_id = Folder.all.shuffle.first.id
    e.name = Faker::Lorem.word
    e.user_id  = owner.id
    e.description = Faker::Lorem.paragraphs
  end
end
