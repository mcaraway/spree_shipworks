Spree::Core::Engine.add_routes do
  namespace :shipworks do
    post '/' => 'api#action'
  end
end
