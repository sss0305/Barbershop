require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'smth wrong'
	erb :about
end

get '/visit' do
	erb :visit

end

get '/contacts' do
	erb :contacts
end

get '/admin' do
	erb :admin
end

post '/visit' do
        @username = params[:username]
        @phone = params[:phone]
        @datetime = params[:datetime]
        @barber = params[:barber]
        @color = params[:color]

        hh = {  :username => 'Введите ваше имя',
        		:phone => 'Введите ваш телефон',
        		:datetime => 'Выберите дату'
        		 }

        #Выводит ошибка валидации но только одну, внизу улучшение кода
        #hh.each do |key, value|
        #	if params[key] == ''
        #		@error = hh[key]
        #		return erb :visit
        #	end
        #end

		@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

			if @error != ''
				return erb :visit
			end


        @title = 'Thanks'
        @message = "Dear, #{@username}, barber #{@barber} will be waiting for you at #{@datetime}. color: #{@color}"
        @f = File.open './public/users.txt', 'a'
        @f.write "User: #{@username}, phone: #{@phone}, date and time: #{@datetime}, barber: #{@barber}, color: #{@color}\n"
        @f.close

        erb :message

end

post '/contacts' do
require 'pony'

        @username = params[:username]
        @email = params[:email]
        @text = params[:text]


        cc = {  :username => 'Введите ваше имя',
        		:email => 'Введите ваш email',
        		:text => 'Введите ваш запрос'
        		 }

        @error = cc.select {|key,_| params[key] == ""}.values.join(", ")

			if @error != ''
				return erb :contacts
			end



        @title = "Thanks"
        @message = "Dear, #{@username}, we will contact you soon"

        @c = File.open './public/contacts.txt', 'a'
        @c.write "User: #{@username}, email: #{@email}, text: #{@text}\n"
        @c.close

        erb :message

	   Pony.mail(
	  :username => params[:username],
	  :email => params[:email],
	  :text => params[:text],
	  :to => 'syutkin.s@gmail.com',
	  :subject => params[:name] + " has contacted you",
	  :body => params[:message],
	  :port => '587',
	  :via => :smtp,
	  :via_options => { 
	    :address              => 'smtp.gmail.com', 
	    :port                 => '587', 
	    :enable_starttls_auto => true, 
	    :user_name            => 'lumbee', 
	    :password             => 'Treptow235870!', 
	    :authentication       => :plain, 
	    :domain               => 'localhost.localdomain'
	  })

end

post '/admin' do
    @login = params[:login]
    @password = params[:password]
    @title = params[:title]

    if @login == 'admin' && @password == 'secret'
        @title = "Thanks"
       	@message = "Hi, #{@login}, you are loggen in"

        @file = File.open("./public/users.txt","r")
                #erb :welcome_a

        #elsif @login == 'admin' and @password == 'admin'
         #       @message = 'login and password are the same, try again'
                #erb :index
        #elsif @login == 'admin' and @password != 'secret'
                #@message = 'your password is wrong, try again'
                #erb :index
        #elsif @login != 'admin' and @password == 'secret'
                #@message = 'your login is wrong, try again'
                #erb :index
    else
        @message = 'access denied'

    end
end
