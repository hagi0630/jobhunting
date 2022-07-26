class ApplicationController < ActionController::Base
    # セッションに何も無ければログイン画面に飛ばす
    def redirect_to_signin
        redirect_to signin_path if session[:user_id].blank?
    end

end
