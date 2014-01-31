module Spree
  module Shipworks
    class GetStore
      include Dsl
      def call(params)
        response do |r|
          r.element "Store" do |r2|
            r2.element "Name", "#{Spree::Config[:site_name]}"
            r2.element "CompanyOrOwner", "Customer Support"
            r2.element "Website", "#{Spree::Config[:site_url]}"
          end
        end
      end
    end
  end
end