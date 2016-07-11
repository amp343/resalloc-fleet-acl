Rails.application.routes.draw do

  devise_for :users
  get    '/resources', to: 'resources#index', as: 'resources_index'
  get    '/resources/leased', to: 'resources#leased_to_user', as: 'leased_resources'
  get    '/resources/:name', to: 'resources#show', as: 'resources_show'
  post   '/resources/:name/lease', to: 'resources#lease', as: 'lease_resource'
  delete '/resources/:name/lease', to: 'resources#unlease', as: 'unlease_resource'
end
