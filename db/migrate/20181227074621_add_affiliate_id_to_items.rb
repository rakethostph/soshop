class AddAffiliateIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :affiliate_id, :integer
  end
end
