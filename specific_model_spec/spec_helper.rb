dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"

require 'rubygems'
require 'spec'
require 'pp'
require 'cache_money'
require 'memcache'
require File.join(dir, '../config/environment')

Spec::Runner.configure do |config|
  config.mock_with :rr
  config.before :suite do
    load File.join(dir, "../db/schema.rb")

    config = YAML.load(IO.read((File.expand_path(File.dirname(__FILE__) + "/../config/memcache.yml"))))['test']
    $memcache = MemCache.new(config)
    $memcache.servers = config['servers']
    $lock = Cash::Lock.new($memcache)
  end

  config.before :each do
    $memcache.flush_all
    Story.delete_all
  end

  config.before :suite do
    Character = Class.new(ActiveRecord::Base)
    Story = Class.new(ActiveRecord::Base)
    Card = Class.new(ActiveRecord::Base)

    Story.has_many :characters
  end
end
