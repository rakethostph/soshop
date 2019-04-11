class CreateAffiliates < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliates do |t|
      t.string :affiliate_company
      t.string :affiliate_name
      t.string :affiliate_id

      t.timestamps
    end
  end
end
