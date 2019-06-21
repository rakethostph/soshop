class AddCategoryIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :category_id, :integer
    add_column :items, :category_name, :string
  end
end
