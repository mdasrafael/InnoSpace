class StatusMailer < ApplicationMailer
  default from: "rafael.innospace@gmail.com"

  def status_email(user)
    @user = user
    @url  = 'http://localhost:3000/login'
    mail(to: @user.email,
         subject: 'Welcome to My Awesome Site',
         template_path: 'layouts',
         template_name: 'mailer')
=begin
    @user = user
    mail(to: @user.email, subject: 'Status Email')
=end
  end
end
