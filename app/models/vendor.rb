# == Schema Information
#
# Table name: vendors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tel        :string(255)
#  address    :string(255)
#  short_desc :text(65535)
#  desc       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string(255)
#

class Vendor < ActiveRecord::Base
  include UUID
  validates :name, :tel, :address, :short_desc, :desc, presence: true
  validates :name, uniqueness: true

  has_many :materials

  def destructive?
    !materials.exists?
  end
end
