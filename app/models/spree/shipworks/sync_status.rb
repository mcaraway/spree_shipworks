class Spree::Shipworks::SyncStatus < ActiveRecord::Base
  belongs_to :order
end
