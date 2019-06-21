json.extract! category, :id, :category_name, :category_url, :created_at, :updated_at
json.url category_url(category, format: :json)
