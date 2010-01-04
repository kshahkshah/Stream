#!/usr/bin/env ruby

# Modified from about.com of all places
require 'optparse'
require 'rubygems'
require 'mail'
require 'activerecord'
require 'acts-as-taggable-on'
require 'paperclip'

# This hash will hold all of the options parsed from the command-line by OptionParser.
options = {}

optparse = OptionParser.new do |opts|
  # Set a banner, displayed at the top of the help screen.
  opts.banner = "Usage: ingest_stream_emails.rb [options]" # file1 file2 ..."

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  options[:debug] = false
  opts.on( '-d', '--debug', 'Use `test_email` in place of standard in' ) do
    options[:debug] = true

    require 'ruby-debug'
    Debugger.start
  end

  options[:env] = nil
  opts.on( '-e', '--env ENVIRONMENT', 'Set environment, defaults to production' ) do |environment|
    options[:env] = environment
  end

  options[:logfile] = nil
  opts.on( '-l', '--logfile FILE', 'Write log to FILE, defaults to `ingestion.log`' ) do |file|
    options[:logfile] = file
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the email
optparse.parse!

@options = options

puts "Running as #{options[:env]} enviromment..."

puts "Being verbose..." if options[:verbose]

puts "Logging to file #{options[:logfile]}..." if options[:logfile]
@logger = Logger.new(options[:logfile] || (File.dirname(__FILE__) + "/ingestion.log"))

RAILS_ROOT = options[:env].eql?("development") ? "/Users/kunalshah/Sites/stream" : "/var/www/stream/current"
puts "Using stream application at #{RAILS_ROOT}..." if options[:verbose]

# Get the database config
puts "Loading database configuration..." if options[:verbose]
params = YAML.load_file(RAILS_ROOT + "/config/database.yml")[options[:env]]

# Create a logger so logger calls don't blow up
ActiveRecord::Base.logger = @logger

# Manually connect to AR
puts "Establishing database connection..." if options[:verbose]
ActiveRecord::Base.establish_connection(params)

puts "Manually initializing plugins (just act as taggable for now)..." if options[:verbose]
ActiveRecord::Base.send :include, ActiveRecord::Acts::TaggableOn
ActiveRecord::Base.send :include, ActiveRecord::Acts::Tagger

# Require the element model
puts "Loading the element model..." if options[:verbose]
require "#{RAILS_ROOT}/app/models/stream.rb"
require "#{RAILS_ROOT}/app/models/email_stream.rb"
require "#{RAILS_ROOT}/app/models/element.rb"

class Ingester
  class << self

    def start!(options={})
      # Read in the Email
      puts "Starting ingestion..." if options[:verbose]
      raw_mail = options[:debug] ? `cat test_email` : STDIN.read

      # Create a Mail object, thank you mikel
      puts "Creating mail object..." if options[:verbose]
      @email = Mail::Message.new(raw_mail)

      puts "Opening Stream..." if options[:verbose]
      Stream.open(@email,options)
      puts "Finished." if options[:verbose]
    end

  end
end

Ingester.start! options