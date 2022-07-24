class UsersController < ApplicationController
    
    before_action :redirect_to_signin, only: [:edit,:update]
    
    def new
        @user = User.new
    end
    
    def create
        user_params = params.require(:user).permit(:login_id,:password,:password_confirmation)
        @user = User.new(user_params)
        if @user.save
            flash[:notice] = "登録しました"
            redirect_to signin_path
        else
            flash[:alert] = "既にこのユーザーIDは使われているか、パスワードが一致していません"
            render "new"
        end
    end
    
    
    def edit
        @user = User.find(session[:user_id])
    end
    
    def update
        @user = User.find(session[:user_id])
         user_params = params.require(:user).permit(:login_id)
         if @user.update(user_params)
             flash[:notice] = "更新しました"
             redirect_to companies
         else
             flash.now[:alert] = "更新に失敗しました"
             render "edit"
         end
    end    
end
