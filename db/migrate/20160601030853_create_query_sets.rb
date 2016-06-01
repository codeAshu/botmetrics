class CreateQuerySets < ActiveRecord::Migration
  def change
    create_table :query_sets do |t|
      t.string :name
      t.string :provider

      t.timestamps
    end
  end
end
