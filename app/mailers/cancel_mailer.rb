class CancelMailer < ApplicationMailer
  def send_cancel_request(params)
    @params = params
    mail(to: ENV['ADMIN_EMAIL'], :subject => "New cancellation request")
  end
end
