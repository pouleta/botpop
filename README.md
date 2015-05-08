# botpop
[![Code Climate](https://codeclimate.com/github/pouleta/botpop/badges/gpa.svg)](https://codeclimate.com/github/pouleta/botpop)

## Usage

Ruby 2 or greater is required. To be compatible with Ruby 1.9, you can try :
``sed 's/prepend/include/g' -i botpop.rb`` but no garanties...

``bundle install`` to install the gems.


## Arguments
By default, only the first occurence of the argument will be used, unless specified.
- --channels, -c _OPTION_ : list of channels (default __equilibre__)
- --ip, -s _OPTION_ : server ip (default to __freenode__)
- --port, -p _OPTION_ : port (default __7000__ or __6667__ if no ssl)
- --no-ssl : disable ssl (__enabled__ by default)
- --nick, -n _OPTION_ : change the __nickname__
- --user, -u _OPTION_ : change the __username__
- --config _OPTION_ : change the plugin configuration file (default to ``modules_config.yml``)
- --plugin-directory _OPTION_ : change the directory where the plugins are installed (default ``plugins/``)
- --plugin-disable _OPTION_ : disable a plugin (can be specified many times)
- --debug, -d _OPTION_ : enable the debug mod. It et a global __$debug_OPTION__ to true. (can be specified many times)

### Debugging easier
You can specify the --debug OPT option at program start.
It will define as many __$debug_OPT__ globals to enable debug on the plugins.

As example:
```ruby
# If debug enabled for this options and error occured
if $debug_plugin and variable == :failed
  binding.pry # user hand here
  # Obsiously, it is usefull to trylock a mutex before because the bot use
  # Threads and can call many times this binding.pry
end
```

# Plugins

Some official plugins are developped. You can propose your own creation by pull request, or add snippets link to the wiki.

## List
- Base : this is a basic plugin, providing __version, code, help, and troll__
- Network : an usefull plugin with commands __ping, ping ip, ping http, traceroute, dos attack and poke__
- Searchable : a little plugin providing irc research with engines like __google, wikipedia, ruby-doc, etc...__
- Coupon : the original aim of the bot. It get coupons for the challenge __pathwar__
- Intranet : an useless plugin to check the intranet of epitech

## Create your own
You can easy create your own plugins. The documentation will be finished later.
The bot is based on [Cinch framework](https://github.com/cinchrb/cinch/).
You should take a' ride in their documentation before developping anything.

### Example of new plugin
First, put your ruby code file in ``plugins/``, and put your code in the scope :
```ruby
module BotpopPlugins
  module MyFuryPlugin
    def self.exec_whatkingofannimal m
      m.reply "Die you son of a + ["lion", "pig", "red panda"].shuffle.first + " !!"
    end
    ...code...
  end
end
```

### Matching messages
To create a matching to respond to a message, you have to specifie in your plugin :
```ruby
module BotpopPlugins
  module MyFuryPlugin
    MATCH = lambda do |parent|
      parent.on :message, /!whatkingofannimal.*/ do |m| BotpopPlugins::exec_whatkingofannimal m end
    end
    ...code...
  end
end
```
