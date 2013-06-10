module YmMessages::MessagesHelper

  def day(message)
    message.created_at.strftime("%d %b")
  end

  def switch_text(user)
    if user.no_private_messaging?
      text = ['you cannot send or receive private messages']
    else
      text = ['you can send and receive private messages from other users']
    end
    if user.email_for_new_message?
      text << 'you will receive emails about new messages'
    else
      text << "you won't receive emails about new messages"
    end
    "As things stand, #{text.to_sentence}. You can change these settings using the button."
  end
  
  def time(message)
    message.created_at.strftime("%H:%M")
  end
  
  
  def unread_class(thread, user)
    'unread' if thread.is_unread?(user)
  end

  def user_names(thread)
    names = []
    thread.users.each do |user|
      (names << user) if user != current_user      
    end
    names.join(', ').html_safe
  end

end