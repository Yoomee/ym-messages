module YmMessages::UsersHelper

  def unread_message_count
    @unread_message_count ||= current_user.try(:unread_message_count).to_i
  end

end