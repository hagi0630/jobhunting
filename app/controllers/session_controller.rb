class SessionController < ApplicationController
    
    before_action :redirect_to_companies, only: [:new, :create]
    
    
    def new
    end
    
    def create
        user = User.find_by(login_id: params[:login_id])
        if user.present? &&  user.authenticate(params[:password])
            flash[:notice] = "ログインしました"
            session[:user_id] = user.id
            redirect_to companies_path
        else
            flash.now[:alert] = "ログインに失敗しました"
            render "new"
        end
    end
    
    def destroy
        session[:user_id] = nil
        redirect_to signin_path
    end

    private
    
    def redirect_to_companies
        redirect_to companies_path if session[:user_id].present?
    end
end
