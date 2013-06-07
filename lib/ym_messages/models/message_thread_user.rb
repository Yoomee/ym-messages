module YmMessages::MessageThreadUser

  def self.included(base)
    base.send(:include, YmCore::Model)
        
    base.belongs_to :message_thread
    base.belongs_to :user, :class_name => "User"
  end
  
  def set_unread!
    update_attribute(:not_read, true)
  end
  
  def set_read!
    update_attribute(:not_read, false)
  end
  
  def self.unread_message_count_for_user(user_id)
    self.class.where("user_id = #{user_id} AND not_read = 1").count
  end
  
end
