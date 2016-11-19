
json.entities @entities do |entity|
  json.category_name entity.category.try(:name)
  json.name entity.name
  json.skp_file Setting.host + entity.skp_file_url
  json.skp_file_size number_to_human_size(File.size(entity.skp_file.path))
  json.created_at_normal entity.created_at.to_s(:cn_short_normal)
  #json.description entity.description
  json.uuid entity.uuid
  #json.icon entity.icon.thumb.url || image_path('model.jpeg')
  json.icon image_url(entity.try(:icon).try(:url)) if entity.icon.try(:url)
end

json.status "ok"
