# Load the Rails application.
require File.expand_path('../application', __FILE__)

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address        => 'smtp.gmail.com',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['GMAIL_USERNAME'],
    :password       => ENV['GMAIL_PASSWORD'],
    :domain         => 'gmail.com',
    :enable_starttls_auto => true,
  }
end

# Initialize the Rails application.
Rails.application.initialize!
