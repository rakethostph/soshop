class CreateSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_categories do |t|
      t.integer :category_id
      t.string :subcategory_name
      t.string :sub_category_url

      t.timestamps
    end
  end
end
