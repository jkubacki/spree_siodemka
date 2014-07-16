Spree::Core::Engine.routes.append do
  namespace :admin do
    get 'siodemka', to: 'siodemka#test'
  end
end