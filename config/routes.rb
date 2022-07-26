Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "companies#index"  # 最初のデフォルト画面は会社一覧画面へ。セッションIDがない場合はログイン画面に飛ぶ
  get "/companies", to: "companies#index"  #会社一覧画面へ
  post "/companies",to: "companies#create"  #会社新規登録
  get "/companies/new", to: "companies#new", as:"new_company"  #会社新規登録画面へ
  get "/companies/:id/edit", to: "companies#edit", as:"edit_company"  #会社編集画面へ
  get "/companies/:id", to: "companies#show", as:"company"  #会社詳細画面へ
  patch "/companies/:id",to: "companies#update"  #会社情報更新
  delete "/companies/:id", to: "companies#destroy"  #会社情報消去
  
  get "/signup", to: "users#new"  #ユーザー新規登録画面へ
  post "/signup", to: "users#create"  #ユーザー新規登録
  get "/users/edit", to: "users#edit", as: "edit_user"  #ユーザー情報編集画面へ
  patch "/user", to: "users#update", as: "user"  #ユーザー情報更新
  get "/signin", to: "session#new"  #ログイン画面へ
  post "/signin", to: "session#create"  #ログイン情報更新
  get "/signout", to: "session#destroy"  #ログアウト処理
end
