require './student'
require './volunteer'
require 'sinatra'
require 'slim'
require 'sass'

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
	enable :sessions
	set :username, 'organization'
	set :password, 'mooc'
end

get '/login' do
	slim :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
	   session[:admin] = true
	   redirect to ('/students')
	else
		slim :login
	end
end

get '/logout' do
	session.clear
	redirect to('/login')
end

get('/styles.css'){ scss :styles }

get '/' do 
	slim :home
end

get '/moocs' do
	@title = "List of MOOCs"
	slim :moocs
end

get '/about' do
	@title = "About this website"
	slim :about
end

get '/contact' do
	@title = "Any questions?"
	slim :contact
end

not_found do
	slim :not_found
end

get '/students' do
	halt(401, 'Not Authorized') unless session[:admin]
	@students = Student.all
	slim :students
end

get 'students/new' do
	@student = Student.new
	slim :new_student
end

post '/students' do
	student = Student.create(params[:student])
	redirect to ("/students/#{student.id}")
end

get '/students/:id' do
	@student = Student.get(params[:id])
	slim :show_student
end

get 'students/:id/edit' do
	@student = Student.get(params[:id])
	slim :edit_student
end

put '/students/:id' do
	student = Student.get(params[:id])
	student.update(params[:student])
	redirect to("/students/#{student.id}")
end

get '/volunteers' do
	@volunteers = Volunteer.all
	slim :volunteers
end

get '/volunteers/new' do
	halt(401, 'Not Authorized') unless session[:admin]
	@volunteer = Volunteer.new
	slim :new_volunteer
end

get '/volunteers/:id' do
	@volunteer = Volunteer.get(params[:id])
	slim :show_volunteer
end

post '/volunteers' do
	volunteer = Volunteer.create(params[:volunteer])
	redirect to("/volunteers/#{volunteer.id}")
end

get '/volunteers/:id/edit' do
	@volunteer = Volunteer.get(params[:id])
	slim :edit_volunteer
end

put '/volunteers/:id' do
	volunteer = Volunteer.get(params[:id])
	volunteer.update(params[:volunteer])
	redirect to("/volunteers/#{volunteer.id}")
end

delete '/volunteers/:id' do
	Volunteer.get(params[:id]).destroy
	redirect to('/volunteers')
end