Rails.application.routes.draw do
  root to: "home#index"

  # 第三方引擎的路由
  use_doorkeeper

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register' }

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # 自定义路由
  resources :probe_settings, only: [:create, :destroy]

  resources :web_spider_settings, only: [:create, :destroy]

  scope module: 'rss' do
    get 'rss' => 'rss#index', as: 'rss'

    resources :rss_feeds, only: [] do
      collection do
        get :unread_count
        put :mark_readed
        get :load_more_rss_feed
      end
    end
  end

  scope module: 'goods' do
    resources :goods, only: [] do
      collection do
        get 'comments'
        get 'prices'
        get 'coupons'
        get 'ads'
        get 'names'
      end
    end
  end

  post 'sql' => 'sql#sql'

  get 'running_jobs_count' => 'jobs_management/jobs_management#running_jobs_count', as: 'running_jobs_count'
  post 'start_job' => 'jobs_management/jobs_management#start_job', as: 'start_job'
  post 'start_all_job' => 'jobs_management/jobs_management#start_all_job', as: 'start_all_job'
  delete 'delete_job' => 'jobs_management/jobs_management#delete_job', as: 'delete_job'

  get 'rss_list' => 'rss/rss_feeds#rss_list', as: 'rss_feed_rss_list'

  get 'histories' => 'histories/histories#histories', as: 'histories'
end
