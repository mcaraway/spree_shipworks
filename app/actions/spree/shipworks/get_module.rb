module Spree
  module Shipworks
    class GetModule
      include Dsl
      def call(params)
        response do |res|
          res.element "Module" do |r|
            r.element "Platform", "Spree"
            r.element "Developer", "Caraway Tea Company, LLC (http://www.uniqteas.com)"
            r.element "Capabilities" do |r2|
              r2.element "DownloadStrategy", "ByModifiedTime"
              r2.element "OnlineCustomerID", 'supported' => 'true', 'dataType' => 'numeric'
              r2.element "OnlineStatus", 'supported' => 'true', 'dataType' => 'text', 'supportsComments' => 'false'
              r2.element "OnlineShipmentUpdate", 'supported' => 'true'
            end
          end
        end
      end
    end
  end
end