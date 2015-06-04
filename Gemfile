source 'http://rubygems.org'
ruby '2.2.0'

gem 'sinatra'
gem 'thin'
gem 'json'
gem 'rdiscount'

gem 'config_env'
gem 'rake'

gem 'activerecord'
gem 'sinatra-activerecord'
gem 'protected_attributes'

gem 'rbnacl-libsodium'
gem 'jwt'

group :development do
  gem 'shotgun'
end

group :test do
  gem 'minitest'
  gem 'rack'
  gem 'rack-test'
end

group :development, :test do
  gem 'config_env'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
