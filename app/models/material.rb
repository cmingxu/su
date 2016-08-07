# == Schema Information
#
# Table name: materials
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  vendor_id  :integer
#  icon       :string(255)
#  price      :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string(255)
#  code       :string(255)
#

class Material < ActiveRecord::Base
  include UUID
  validates :name, :icon, :vendor_id, :code, :price, presence: true
  validates :price, numericality: true
  validates :name, uniqueness: { scope: :vendor_id }
  validates :code, uniqueness: true

  belongs_to :vendor
  mount_uploader :icon, MaterialIconUploader
end
