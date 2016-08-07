module UUID
  extend ActiveSupport::Concern

  included do |base|
    base.before_create do
      self.uuid = SecureRandom.uuid
    end

    def self.find_by_uuid(uuid)
      find_by(uuid: uuid)
    end
  end
end
