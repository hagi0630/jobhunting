require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "date"
require "fileutils"

class CalendarController < ApplicationController
  

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

  def index
    register("test","2022-08-29T10:00:00","2022-08-29T17:00:00")
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


  def callback
    session[:code] = params[:code]
    logger.debug(session[:code])
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.client_options.application_name = APPLICATION_NAME
    calendar.authorization = authorize
    calendar_id = MY_CALENDAR_ID
    now = DateTime.now + 1
    @response = calendar.list_events(calendar_id,
                                    max_results:   5,
                                    single_events: true,
                                    order_by:      "startTime",
                                    time_min:      DateTime.new(now.year,now.month,now.day,0,0,0),
                                    time_max:      DateTime.new(now.year,now.month,now.day,23,59,59) )
    @exist = 1
    @exist = 2 if @response.items.empty?

  end
  
  # カレンダー登録。summaryにタイトル、startTimeに'2015-05-28T09:00:00-07:00'みたいな感じで始まる時間書く
  def register(summary,startTime,endTime)
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

  def fetchEvents(service)
    # Fetch the next 10 events for the user
    calendar_id = MY_CALENDAR_ID
    response = service.list_events(calendar_id,
                                  max_results:   10,
                                  single_events: true,
                                  order_by:      "startTime",
                                  time_min:      DateTime.now.rfc3339)
    puts "Upcoming events:"
    puts "No upcoming events found" if response.items.empty?
    response.items.each do |event|
      start = event.start.date || event.start.date_time
      puts "- #{event.summary} (#{start})"
    end
  end
end