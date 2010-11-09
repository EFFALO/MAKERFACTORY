source :rubygems

gem 'bundler', "~>1.0.0"
gem 'rails', "3.0.1"
gem 'paperclip', "2.3.1.1"
gem 'will_paginate'
gem 'authlogic'
gem 'haml'
gem 'factory_girl'
gem 'faker'
gem 'cancan', "~>1.3.0"

group :pre_boot do
  gem 'refraction'
end

group :development do
  gem 'sqlite3-ruby'
  gem 'awesome_print', :require => 'ap'
  gem 'capistrano'
  gem 'heroku'
end

group :production do
  gem 'mysql'
  gem 'hoptoad_notifier'
  gem 'aws-s3'
end

group :test do 
  gem 'timecop'
  gem 'rspec', "~>1.3.0", :require => false
  gem 'rspec-rails', "~>1.3.2", :require => false
end
