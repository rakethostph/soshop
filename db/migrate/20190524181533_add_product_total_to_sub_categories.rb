class AddProductTotalToSubCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :sub_categories, :product_total, :integer
  end
end
