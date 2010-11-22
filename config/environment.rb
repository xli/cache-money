require 'active_record'

# ActiveRecord::Base.establish_connection(
#   :adapter => 'sqlite3',
#   :dbfile => ':memory:'
# )
ActiveRecord::Base.establish_connection(
  :database => 'cache_money',
  :adapter => 'postgresql',
  :username => 'postgres',
  :password => 'sa',
  :host => 'localhost',
  :port => 5432,
  :min_messages => 'ERROR'
)
