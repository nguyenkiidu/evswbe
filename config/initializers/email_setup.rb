ActionMailer::Base.delivery_method = :smtp
  
ActionMailer::Base.smtp_settings = {
  :user_name => 'mysmaily',
  :password => 'Labocom2018',
  :domain => 'eventswish.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}