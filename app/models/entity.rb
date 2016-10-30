# == Schema Information
#
# Table name: entities
#
#  id          :integer          not null, primary key
#  category_id :integer
#  name        :string(255)
#  skp_file    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  description :text(65535)
#  icon        :string(255)
#  uuid        :string(255)
#  is_system   :boolean          default(FALSE)
#  visible     :boolean          default(TRUE)
#

class Entity < ActiveRecord::Base
  include UUID
  belongs_to :user
  belongs_to :category
  belongs_to :style

  validates :name, presence: { message: '名称不能空' }
  validates :name, uniqueness: { scope: :user_id, message:  '名称冲突'}
  validates :skp_file, presence: { message: '必须上传' }
  validates :icon, presence: { message: '必须上传' }

  scope :site_level, -> { where(is_system: true) }
  scope :visible, -> { where(visible: true) }

  mount_uploader :skp_file, SkpFileUploader
  mount_uploader :icon, EntityIconUploader

end
