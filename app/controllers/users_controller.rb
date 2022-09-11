class UsersController < ApplicationController
    
    before_action :redirect_to_signin, only: [:edit,:update]
    
    # 新規登録画面
    def new
        @user = User.new
    end
    
    # 新規登録画面から貰ったデータでデータベースに登録
    def create
        user_params = params.require(:user).permit(:login_id,:password,:password_confirmation)
        @user = User.new(user_params)
        logger.debug("!!!!")
        logger.debug(user_params)
        logger.debug(@user.password.present?)
        logger.debug(@user.password_confirmation)
        if @user.save
            flash[:notice] = "登録しました"
            redirect_to signin_path
        else
            flash[:alert] = "既にこのユーザーIDは使われているか、パスワードが一致していません"
            render "new"
        end
    end
    
    
    # ユーザー情報編集画面
    def edit
        @user = User.find(session[:user_id])
    end
    
    # ユーザー情報編集画面からもらったデータでデータベースに反映
    def update
        @user = User.find(session[:user_id])
         user_params = params.require(:user).permit(:login_id)
         if @user.update(user_params)
             flash[:notice] = "更新しました"
             redirect_to companies_path
         else
             flash.now[:alert] = "更新に失敗しました"
             render "edit"
         end
    end    
end
