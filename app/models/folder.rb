# == Schema Information
#
# Table name: folders
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  entity_count :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  uuid         :string(255)
#  is_system    :boolean          default(FALSE)
#

class Folder < ActiveRecord::Base
  include UUID

  scope :site_level, -> { where(is_system: false) }
  belongs_to :user
  has_many :entities
end
