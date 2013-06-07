require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")


class Volunteer
	include DataMapper::Resource
	property :id, Serial
	property :field, String
	property :place, String
	property :organization, String
	property :vacancy, String
	property :description, Text
	property :posted_on, Date 

	def posted_on=date
		super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize