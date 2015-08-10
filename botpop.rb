#!/usr/bin/env ruby
#encoding: utf-8

if RUBY_VERSION.split('.').first.to_i == 1
  raise RuntimeError, "#{__FILE__} is not compatible with Ruby 1.X."
end

require 'cinch'
require 'uri'
require 'net/ping'
require 'pry'
require 'yaml'
require 'colorize'

require_relative 'arguments'
require_relative 'botpop_plugin_inclusion'
require_relative 'builtins'

class BotpopPlugin
  def config
    Botpop::CONFIG[self.class.to_s]
  end
end

class Botpop

  def self.load_version
    begin
      return IO.read('version')
    rescue Errno::ENOENT
      puts "No version specified".red
      return "???"
    end
  end

  def self.include_plugins
    PluginInclusion.plugins_include! ARGUMENTS
  end

  def self.load_plugins
    Module.constants.select{ |m|
          (m = Module.const_get(m) rescue false) and
            (m.is_a?(Class)) and
            (m.ancestors.include?(BotpopPlugin)) and
            (m != BotpopPlugin)
    }.map{|m| Module.const_get(m)}
  end

  # FIRST LOAD THE CONFIGURATION
  ARGUMENTS = Arguments.new(ARGV)
  VERSION = load_version()
  CONFIG = YAML.load_file(ARGUMENTS.config_file)
  TARGET = /[[:alnum:]_\-\.]+/
  include_plugins()
  PLUGINS = load_plugins()

  def start
    @engine.start
  end

  def initialize
    @engine = Cinch::Bot.new do
      configure do |c|
        c.server = ARGUMENTS.server
        c.channels = ARGUMENTS.channels
        c.ssl.use = ARGUMENTS.ssl
        c.port = ARGUMENTS.port
        c.user = ARGUMENTS.user
        c.nick = ARGUMENTS.nick
        c.plugins.plugins = PLUGINS
      end
    end
  end

end

if __FILE__ == $0
  $bot = Botpop.new
  trap("SIGINT") do
    puts "\b"
    puts "SIGINT Catched"
    exit
  end
  $bot.start
end
