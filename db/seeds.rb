# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: "cming.xu@gmail.com", password: "cming.xu@gmail.com", roles: ["admin"])
owner = User.create!(email: "siteowner@siteowner.com", password: "siteowner@siteowner", roles: ["siteowner", "user"])
User.create!(email: "user@user.com", password: "user@user", roles: ["user"])

%w(门窗 衣橱 厨房 卫生间 卧室 沙发 电视柜).each do |f|
  Folder.create name: f, user_id: owner.id
end 


suckr = ImageSuckr::GoogleSuckr.new

100.times do
  Entity.create do |e|
    e.folder_id = Folder.all.shuffle.first.id
    e.name = Faker::Lorem.word
    e.user_id  = owner.id
    e.description = Faker::Lorem.paragraphs
    e.remote_icon_url = suckr.get_image_url({"q" => "car"})
  end
end
