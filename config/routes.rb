Rails.application.routes.draw do
  #トップページにアクセスしたときのルーティングをtoppagesController の index アクションに設定。
  root to: 'toppages#index' 

=begin
追加した3行⇩は、いずれも7つの基本アクションから外れておらず、
resources :sessions, only: [:new, :create, :destroy] としても良いが、
URL の見栄えを考慮して、個別にルーティングを設定。
=end
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create] do
    #フォロー中のユーザとフォローされているユーザ一覧を表示するページ。
    member do
      get :followings
      get :followers
      get :favorites
    end
  end

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  #ログインユーザがユーザをフォロー／アンフォローできるようにするルーティング。
  resources :favorites, only: [:create, :destroy]
end

=begin
#  # CRUD
  get 'messages/:id', to: 'messages#show'
  post 'messages', to: 'messages#create'
  put 'messages/:id', to: 'messages#update'
  delete 'messages/:id', to: 'messages#destroy'

  # index: show の補助ページ
  get 'messages', to: 'messages#index'

  # new: 新規作成用のフォームページ
  get 'messages/new', to: 'messages#new'

  # edit: 更新用のフォームページ
  get 'messages/:id/edit', to: 'messages#edit'
=end

=begin
Rails.application.routes.draw do
  resources :messages
end
=end