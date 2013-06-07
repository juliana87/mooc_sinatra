require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Student
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :e_mail, String
	property :rank, Integer
	property :activity_level, Integer
	property :volunteer, Boolean
end

DataMapper.finalize
