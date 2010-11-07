HoptoadNotifier.configure do |config|
   config.api_key = ENV['ERRBIT_KEY']
   config.host    = ENV['ERRBIT_HOST']
   config.port    = 80 # Note: Deployment notifications only work on port 80
end

