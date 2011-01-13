HoptoadNotifier.configure do |config|
  config.api_key = 'KEY' if Rails.env.production? || Rails.env.staging?
end
