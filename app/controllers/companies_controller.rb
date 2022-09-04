require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"
require "active_support/time"

class CompaniesController < ApplicationController
    # 会社を1つ選ぶ処理
    before_action :set_company,only: [:show,:edit,:update,:complete,:destroy,:schedule_company]
    # application_controlle.rbr参照
    before_action :redirect_to_signin
    
    
  REDIRECT_URI = "https://1206095f41114a99811deaf0e84e0e18.vfs.cloud9.ap-northeast-1.amazonaws.com/oauth2callback".freeze
  APPLICATION_NAME = "就活Manager".freeze
  CLIENT_SECRET_PATH = "client_secret.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "credentials.yaml".freeze
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
  MY_CALENDAR_ID = 'primary'
  TIME_ZONE = 'Japan'
    
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
            flash.now[:alert] = "登録に失敗しました。会社名を入れていないか既にある会社名ではないですか？"
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
    
    def schedule_add
    end
    
    def schedule
        companies = Company.where(user_id: session[:user_id])
        task_due_array = []
        companies_name = []
        companies.each do |company|
            companies_name.push(company.name)
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
        @schedule = Company.new
        @companies_name = companies_name.uniq
    end
    
    
    # スケジュール完了。対応するtaskとdueを消す
    def complete
        # dueとtaskは消したところから1つずつずらす
            @company.task4=nil
            @company.due4=nil
        if @company.task1==params[:task] && @company.due1==params[:due]
            @company.task1=@company.task2
            @company.due1=@company.due2
            @company.task2=@company.task3
            @company.due2=@company.due3
            @company.task3=@company.task4
            @company.due3=@company.due4
        elsif @company.task2==params[:task] && @company.due2==params[:due]
            @company.task2=@company.task3
            @company.due2=@company.due3
            @company.task3=@company.task4
            @company.due3=@company.due4
        elsif @company.task3==params[:task] && @company.due3==params[:due]
            @company.task3=@company.task4
            @company.due3=@company.due4
        end
        @company.save
        redirect_to schedule_path
    end
    
    
    # スケジュール画面から会社詳細画面へ
    def schedule_company
    end
    
    def new_schedule
        company_params = params.require(:company).permit(:name,:task,:due)
        company = Company.where(user_id: session[:user_id]).find_by(name:company_params[:name])
        if company.task1.blank? && company.due1.blank?
            company.task1 = company_params[:task]
            company.due1 = company_params[:due]
            # register(company.task1,company.due1.to_s,(company.due1 + 1.hours).to_s)
        elsif company.task2.blank? && company.due2.blank?
            company.task2 = company_params[:task]
            company.due2 = company_params[:due]
            # register(company.task2,company.due2.to_s,(company.due2 + 1.hours).to_s)
        elsif company.task3.blank? && company.due3.blank?
            company.task3 = company_params[:task]
            company.due3 = company_params[:due]
            # register(company.task3,company.due3.to_s,(company.due3 + 1.hours).to_s)
        elsif company.task4.blank? && company.due4.blank?
            company.task4 = company_params[:task]
            company.due4 = company_params[:due]
            # register(company.task4,company.due4.to_s,(company.due4 + 1.hours).to_s)
        else
            flash[:alert] = "taskとdueが満杯です。"
        end
        company.save
        redirect_to schedule_path
    end
    # {"name"=>"freee", "task"=>"aa", "due"=>"2022/08/29 02:00"}

    # 会社情報を削除する
    def destroy
        @company.destroy
        flash[:notice] = "削除しました"
        redirect_to companies_path
    end
    
    # 認証を取ってきてcredentialsというファイルに保存。終了後callbackが呼ばれる
  def authorize
    client_id = Google::Auth::ClientId.from_file CLIENT_SECRET_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "jiangtaiqiuyuan@gmail.com"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      code = session[:code]
      url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
      logger.debug(url)
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: REDIRECT_URI
      )
    end
    credentials
  end
#   
  def callback
    session[:code] = params[:code]
    redirect_to schedule_path
  end
  
    # カレンダー登録。summaryにタイトル、startTimeに'2015-05-28T09:00:00-07:00'みたいな感じで始まる時間書く
  def register(summary,startTime,endTime)
    #   googleカレンダーに登録できるように変換
    startTime = startTime.slice(0,10)+"T"+startTime.slice(11,8)
    endTime = endTime.slice(0,10)+"T"+endTime.slice(11,8)
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.client_options.application_name = APPLICATION_NAME
    calendar.authorization = authorize
    calendar_id = MY_CALENDAR_ID
    event = Google::Apis::CalendarV3::Event.new(
        summary: summary,
        start: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: startTime,
          time_zone: TIME_ZONE
        ),
        end: Google::Apis::CalendarV3::EventDateTime.new(
          date_time: endTime,
          time_zone: TIME_ZONE
        )
    )
    calendar.insert_event('primary', event)
  end
    
    private
    
    # 会社を1つ選ぶ処理
    def set_company
        @company = Company.where(user_id: session[:user_id]).find(params[:id])
    end    
    
    
end