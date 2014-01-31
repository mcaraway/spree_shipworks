module Spree
  module Shipworks
    class GetOrders
      include Dsl
      def call(params)
        response do |res|
          res.element 'Orders' do |r|
            Spree::Shipworks::Orders.since_in_batches(params['start'], params['maxcount']) do |order|
              next if already_sent_to_shipworks?(order)
              order.to_shipworks_xml(r)
              save_sync_status(order)
            end
            Spree::Shipworks::EmailInvoices.since_in_batches(params['start'], params['maxcount']) do |invoice|
              next if invoice.shipping_state == "sent_to_shipworks"
              invoice.to_shipworks_xml(r)
              save_sent_status(invoice)
            end
          end
        end
      rescue ArgumentError => error
        error_response("INVALID_VARIABLE", error.to_s + "\n" + error.backtrace.join("\n"))
      rescue => error
        Rails.logger.error(error.to_s)
        Rails.logger.error(error.backtrace.join("\n"))
        error_response("INTERNAL_SERVER_ERROR", error.to_s)
        end
        
       def already_sent_to_shipworks?(order)
         !Spree::Shipworks::SyncStatus.find_by_order_id(order.id).nil?
       end
       
       def save_sync_status(order)
         sync_status = Spree::Shipworks::SyncStatus.new
         sync_status.order = order
         sync_status.sent_to_shipworks = true
         
         sync_status.save!
       end

       def save_sent_status(invoice)
         invoice.shipping_state = "sent_to_shipworks"
         
         invoice.save!
       end
    end
  end
end