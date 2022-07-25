class CompaniesController < ApplicationController
    
    before_action :set_company,only: [:show,:edit,:update,:destroy]
    before_action :redirect_to_signin
    
    def index
        @companies = Company.where(user_id: session[:user_id])
        if params[:name].present?
            @companies = @companies.where("name like ?", "%"+params[:name]+"%")
        end
    end
    
    def show
    end
    
    # 新規作成
    def new
        @company = Company.new
    end
    
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
    
    
    def edit
    end
    
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
    
    def destroy
        @company.destroy
        flash[:notice] = "削除しました"
        redirect_to companies_path
    end
    
    private
    
    def set_company
        @company = Company.where(user_id: session[:user_id]).find(params[:id])
    end    
    
end