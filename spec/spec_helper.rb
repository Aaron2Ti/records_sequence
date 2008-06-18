# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
# ENV["RAILS_ENV"] = "test"
# require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
# require 'spec/rails'
require 'rubygems'
require 'spec'
require 'active_record'
# require 'active_record/fixtures'
current_dir = File.dirname(__FILE__)
require "#{current_dir}/../lib/records_sequence"
require "#{current_dir}/user"

config = YAML::load(IO.read(current_dir + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(current_dir + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])
load(current_dir + "/schema.rb")
