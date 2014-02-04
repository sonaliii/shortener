require 'sinatra'
require 'active_record'
require 'pry'
require 'securerandom'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
	attr_accessible :url, :code
end


###########################################################
# Routes
###########################################################

get '/' do
    @links = Link.find :all # FIXME
    # a = Link.find :all
    # for x in a do
    # 	x.destroy
    # end
    erb :index
end

get '/new' do
    erb :form
end

get '/:code' do
	code = params[:code]
	link = Link.where(code: code).first
	redirect 'http://' + link.url

end

post '/new' do
	allLinks = Link.find :all
	for i in allLinks do
		if i.url == params[:url]
			return i.code		
		end
	end
	randomCode = SecureRandom.hex(3)
	Link.create(url: params[:url], code: randomCode)
	randomCode
end

# MORE ROUTES GO HERE