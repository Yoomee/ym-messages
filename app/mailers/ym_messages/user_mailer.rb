class YmMessages::UserMailer < ActionMailer::Base
  helper YmCore::UrlHelper

  default :from => Settings.site_email
          
  def new_message(message, recipient)
    @message = message
    @user = recipient
    mail(:to => @user.email, :subject => "[#{Settings.site_name}] New message from #{@message.user.full_name}")    
  end
          
end
