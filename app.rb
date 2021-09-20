require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models.rb'
require 'rack/flash'

enable :sessions

configure do
    use Rack::Flash
end
 
helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    if current_user
        redirect '/admin'
    else
        erb :index
    end
end

get '/sign_in' do
    erb :sign_in
end

get '/sign_up' do
    erb :sign_up
end

get '/sign_out' do
    session[:user] = nil
    redirect '/'
end

post '/sign_in' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/admin'
end

post '/sign_up' do
    @user = User.create(name: params[:name], password: params[:password],
    password_confirmation: params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/admin'
end

get '/room' do
    @room = Room.find_by(number: params[:number])
    if @room
        erb :room
    else
        flash[:alert] = '存在しないルームIDです'
        redirect '/'
    end
end

post '/room/ask/:id' do
    @room = Room.find(params[:id])
    Question.create(name: params[:name], content: params[:content], is_done: false, room_id:@room.id)
    flash[:alert] = '質問を投稿できました'
    erb :room
end

get '/admin' do
    if !current_user
        redirect '/'
    end
    @rooms = Room.all
    erb :admin
end

post '/admin/room' do
    while true
        number = ''
        for num in 1..6 do
            number += rand(1..9).to_s
        end
        unless Room.find_by(number: number)
            newRoom = Room.create(number: number)
            UserRoomRelationship.create(user_id: current_user.id, room_id: newRoom.id)
            break
        end
    end
    redirect '/admin'
end

get '/admin/room/:id' do
    @room = Room.find(params[:id])
    erb :admin_room
end

post '/admin/invite/:id' do
    user = User.find_by(name: params[:name])
    if user
        UserRoomRelationship.create(user_id: user.id, room_id: params[:id])
    end
    redirect "/admin/room/#{params[:id]}"
end