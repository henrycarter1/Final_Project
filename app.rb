require 'bundler'
Bundler.require
require 'tilt/haml'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
require './models.rb'

use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2629743.833333,
    :secret => SecureRandom.hex(64)

get '/' do
  @topics = Topic.all
    haml :index
end

get '/signin' do
  haml :signin
end

get '/signup' do
  haml :signup
end

post '/user/create' do
  unique = !(User.first(:username => params[:username]))

  if unique && params[:confirm] == params[:password]
    u = User.new
    u.username = params[:username]
    u.password = params[:password]
    u.save

    session[:uid] = u.id
    redirect '/'
  elsif !unique && params[:confirm] != params[:password]
    @unique = false
    @pass = false
    haml :signup
  elsif !unique && params[:confirm] == params[:password]
    @unique = false
    haml :signup
  elsif unique && params[:confirm] != params[:password]
    @pass = false
    haml :signup
  end
end

post '/user/login' do
  u = User.first(:username => params[:username])

  if u && params[:password] == u.password
    session[:uid] = u.id
  end

  redirect '/'
end

post '/location/view' do
  @t = Topic.first(:name => params[:city])
  @subjects = Subject.all

  haml :cityview
end


post '/location/view/subject' do
  @s = Subject.first(:name => params[:subject])
  @places = @s.places

  haml :subjectview
end

post '/subject/create/:tid' do
  @s = Subject.new
  @s.name = params[:sname]
  @s.topic_id = params[:tid]
  @s.id = params[:id]
  @s.save

  redirect '/location/view/' + params[:tid].to_s
end

post '/topic/create' do
  t = Topic.new
  t.name = params[:tname]
  t.id = params[:id]
  t.save

  redirect '/'
end

post '/place/create/:sid' do
  @pl = Place.new
  @pl.id = params[:id]
  @pl.name = params[:pname]
  @pl.subject_id = params[:sid]
  @pl.save

  haml :postview
end

get '/location/view/subject/:place_id' do
  @pl = Place.first(:id => params[:place_id])
  @posts = @pl.posts
  haml :postview
end

post '/post/create/:uid/:pid' do
  p_id = params[:pid]
  po=Post.new
  po.id = params[:id]
  po.content = params[:content]
  po.place_id = params[:pid]
  po.user_id = params[:uid]
  po.save

  redirect '/location/view/subject/' + p_id.to_s
end

get '/location/view/:tid' do
  @t = Topic.first(:id => params[:tid])
  @subjects = Subject.all

  haml :cityview
end