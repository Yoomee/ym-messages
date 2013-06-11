module YmMessages::MessageThreadUser

  def self.included(base)
    base.send(:include, YmCore::Model)
        
    base.belongs_to :message_thread
    base.belongs_to :user, :class_name => "User"

    base.extend(ClassMethods)
  end

  module ClassMethods
    def unread_message_count_for_user(user_id)
      self.where(:user_id => user_id, :read => false).count
    end
  end

  def set_unread!
    update_attribute(:read, false)
  end
  
  def set_read!
    update_attribute(:read, true)
  end
  
  
end
