Rails.application.routes.draw do
  get '/score', to: 'interface#score'

  get '/game', to: 'interface#game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
