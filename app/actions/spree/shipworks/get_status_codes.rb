module Spree
  module Shipworks
    class GetStatusCodes
      include Dsl
      def call(params)
        response do |res|
          res.element "StatusCodes" do |r|
            Spree::Shipment.state_machine.events.collect(&:name).each do |spree_state|
              r.element "StatusCode" do |r2|
                r2.element "Code", spree_state.to_s
                r2.element "Name", spree_state.to_s.titleize
              end
            end
          end
        end
      end
    end
  end
end