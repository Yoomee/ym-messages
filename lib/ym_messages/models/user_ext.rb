module YmMessages::UserExt
  
  def self.included(base)
    base.has_many(:thread_users, :class_name => 'MessageThreadUser', :foreign_key => :user_id, :dependent => :destroy)
    base.has_many(:threads, :through => :thread_users, :source => :message_thread, :uniq => true)
    base.has_many(:messages, :dependent => :destroy)
    base.scope(:with_private_messaging, base.where(:no_private_messaging => false))
  end

  def has_private_messaging?
    !no_private_messaging?
  end

  def unread_message_count
    MessageThreadUser.unread_message_count_for_user(id)
  end

end