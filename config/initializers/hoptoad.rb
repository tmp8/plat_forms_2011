HoptoadNotifier.configure do |config|
  config.api_key = '98817bb2140e43cb8a7d9feb20ffba3f' if Rails.env.production? || Rails.env.staging?
end
