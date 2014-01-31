class CreateSpreeShipworksSyncStatuses < ActiveRecord::Migration
  def change
    create_table :spree_shipworks_sync_statuses do |t|
      t.integer :order_id
      t.boolean :sent_to_shipworks
      t.boolean :updated_by_shipworks

      t.timestamps
    end
  end
end
