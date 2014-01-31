module Spree
  module Shipworks
    class UpdateShipment
      include Dsl
      def call(params)
        if Spree::Order.exists?(params['order'])
          order = Spree::Order.find(params['order'])

          if sync_status = Spree::Shipworks::SyncStatus.find_by_order_id(order.id)
          sync_status.updated_by_shipworks = true
          sync_status.save!
          end

          shipment = order.shipments.first
          if shipment.try(:update_attributes, { :tracking => params['tracking'] })
            shipment.ship

            response do |r|
              r.element 'UpdateSuccess'
            end
          else
            error_response("UNPROCESSIBLE_ENTITY", "Could not update tracking information for Order ##{params['order']}")
          end

        else
        # let's see if this is an email invoice
          invoice = Spree::EmailInvoice.find_by_order_number(params['order'])
          if invoice.nil?
            error_response("NOT_FOUND", "Unable to find an order with ID of '#{params['order']}'.")
          elsif invoice.try(:update_attributes, { :tracking_number => params['tracking'] })

            response do |r|
              r.element 'UpdateSuccess'
            end
          else
            error_response("UNPROCESSIBLE_ENTITY", "Could not update tracking information for Order ##{params['order']}")
          end
        end
      end
    end
  end
end