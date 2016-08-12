# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pinyin     :string(255)
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :category do
    name "MyString"
    pinyin "MyString"
  end
end
