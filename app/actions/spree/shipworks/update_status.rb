module Spree
  module Shipworks
    class UpdateStatus
      include Dsl
      def call(params)
        if Spree::Order.exists?(params['order'])
          order = Spree::Order.find(params['order'])
          order.shipments.each do |shipment|
            shipment.send("#{params['status']}!".to_sym)
          end

          if sync_status = Spree::Shipworks::SyncStatus.find_by_order_id(order.id)
          sync_status.updated_by_shipworks = true
          sync_status.save!
          end

          response do |r|
            r.element 'UpdateSuccess'
          end

        else
        # let's see if this is an email invoice
          invoice = Spree::EmailInvoice.find_by_order_number(params['order'])
          if invoice.nil?
            error_response("NOT_FOUND", "Unable to find an order with ID of '#{params['order']}'.")
          elsif invoice.try(:update_attributes, { :shipping_state => params['status'] })

            response do |r|
              r.element 'UpdateSuccess'
            end
          else
            error_response("UNPROCESSIBLE_ENTITY", "Could not update shipping status for Order ##{params['order']}")
          end
        end

      rescue StateMachine::InvalidTransition, NoMethodError => error
        error_response("INVALID_STATUS", error.to_s)
      rescue => error
        error_response("INTERNAL_SERVER_ERROR", error.to_s)
        end
    end
  end
end