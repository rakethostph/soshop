json.extract! sub_category, :id, :category_id, :subcategory_name, :sub_category_url, :created_at, :updated_at
json.url sub_category_url(sub_category, format: :json)
