class CompaniesController < ApplicationController
    # 会社を1つ選ぶ処理
    before_action :set_company,only: [:show,:edit,:update,:complete,:destroy]
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
    
    
    def schedule
        companies = Company.where(user_id: session[:user_id])
        task_due_array = []
        companies.each do |company|
            if company[:task1].present? && company[:due1].present?
            task_due_array.push(id:company.id,name:company.name,url:company.url,mypage_id:company.mypage_id,mypage_pwd:company.mypage_pwd,task:company.task1,due:company.due1)
            end
            if company[:task2].present? && company[:due2].present?
            task_due_array.push(id:company.id,name:company.name,url:company.url,mypage_id:company.mypage_id,mypage_pwd:company.mypage_pwd,task:company.task2,due:company.due2)
            end
            if company[:task3].present? && company[:due3].present?
            task_due_array.push(id:company.id,name:company.name,url:company.url,mypage_id:company.mypage_id,mypage_pwd:company.mypage_pwd,task:company.task3,due:company.due3)
            end
            if company[:task4].present? && company[:due4].present?
            task_due_array.push(id:company.id,name:company.name,url:company.url,mypage_id:company.mypage_id,mypage_pwd:company.mypage_pwd,task:company.task4,due:company.due4)
            end
        end
        task_due_array = task_due_array.sort_by {|x| x[:due]}
        @companies = task_due_array
    end
    
    
    # スケジュール完了。対応するtaskとdueを消す
    def complete
        # 1つずつずらす
        if @company.task1==params[:task] && @company.due1==params[:due]
            @company.task1=@company.task2
            @company.due1=@company.due2
            @company.task2=@company.task3
            @company.due2=@company.due3
            @company.task3=@company.task4
            @company.due3=@company.due4
            @company.task4=nil
            @company.due4=nil
        elsif @company.task2==params[:task] && @company.due2==params[:due]
            @company.task2=@company.task3
            @company.due2=@company.due3
            @company.task3=@company.task4
            @company.due3=@company.due4
            @company.task4=nil
            @company.due4=nil
        elsif @company.task3==params[:task] && @company.due3==params[:due]
            @company.task3=@company.task4
            @company.due3=@company.due4
            @company.task4=nil
            @company.due4=nil
        elsif @company.task4==params[:task] && @company.due4==params[:due]
            @company.task4=nil
            @company.due4=nil
        end
        @company.save
        redirect_to schedule_path
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