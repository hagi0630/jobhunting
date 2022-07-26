class CompaniesController < ApplicationController
    # 会社を1つ選ぶ処理
    before_action :set_company,only: [:show,:edit,:update,:destroy]
    # application_controlle.rbr参照
    before_action :redirect_to_signin
    
    # 最初の企業一覧の画面。
    def index
        @companies = Company.where(user_id: session[:user_id])
        # 検索機能が使われたら
        if params[:name].present?
            @companies = @companies.where("name like ?", "%"+params[:name]+"%")
        end
    end
    
    # 1つの会社をみる処理
    def show
    end
    
    # 会社を新規登録する画面に渡す
    def new
        @company = Company.new
    end
    
    # newから貰った情報でデータベースに会社を登録
    def create
        company_params = params.require(:company).permit(:name,:url,:mypage_id,:mypage_pwd,:task1,:due1,:task2,:due2,:task3,:due3,:task4,:due4)
        company_params[:user_id] = session[:user_id]
        @company = Company.new(company_params)
        if @company.save
            flash[:notice] = "会社を1件登録しました"
            redirect_to companies_path
        else
            flash.now[:alert] = "登録に失敗しました"
            render :new
        end
    end
    
    
    # 会社編集画面
    def edit
    end
    
    # editから貰ったデータを使って実際にデータベースに更新する処理
    def update
        company_params = params.require(:company).permit(:name,:url,:mypage_id,:mypage_pwd,:task1,:due1,:task2,:due2,:task3,:due3,:task4,:due4)
        if @company.update(company_params)
            flash[:notice] = "データを1件更新しました"
            redirect_to companies_path
        else
            flash.now[:alert] = "更新に失敗しました"
            render :edit
        end
    end
    
    # 会社情報を削除する
    def destroy
        @company.destroy
        flash[:notice] = "削除しました"
        redirect_to companies_path
    end
    
    private
    
    # 会社を1つ選ぶ処理
    def set_company
        @company = Company.where(user_id: session[:user_id]).find(params[:id])
    end    
    
end