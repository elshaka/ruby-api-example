require 'mail'

options = {
  address: MAIL_SERVER,
  port: 587,
  user_name: MAIL_USERNAME,
  password: MAIL_PASSWORD,
  authentication: 'plain',
  enable_starttls_auto: true
}

Mail.defaults do
  delivery_method :smtp, options
end
