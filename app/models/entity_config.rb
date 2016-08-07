class EntityConfig
  CONFIG = YAML::load(File.read(Rails.root.join("config", "entity_config.yml")))["building_config"].freeze

  def self.name_config
    CONFIG["name_config"]
  end

  def self.material_config
    CONFIG["material_config"]
  end

  def self.attributes_config
    CONFIG["attributes_config"].transform_keys{|k| k.to_s.downcase }
  end
end
