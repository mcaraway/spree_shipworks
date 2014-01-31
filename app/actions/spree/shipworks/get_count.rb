module Spree
  module Shipworks
    class GetCount
      include Dsl
      
      def call(params)
        begin
          Spree::EmailInvoice.get_emails
          order_count = Spree::Shipworks::Orders.since(params['start']).count
          invoice_count = Spree::Shipworks::EmailInvoices.since(params['start']).count
          response do |r|
            r.element "OrderCount", order_count + invoice_count
          end
        rescue ArgumentError
          error_response("INVALID_DATE_FORMAT", "Unable to determine date format for '#{params['start']}'.")
        rescue => error
          puts error.inspect
          Rails.logger.error(error.to_s)
          Rails.logger.error(error.backtrace.join("\n"))
          error_response("INTERNAL_SERVER_ERROR", error.to_s)
        end
      end
    end
  end
end