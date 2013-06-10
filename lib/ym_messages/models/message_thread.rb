module YmMessages::MessageThread

  def self.included(base)
    base.send(:include, YmCore::Model)

    base.has_many :messages, :order => 'messages.created_at', :dependent => :destroy
    base.has_many :thread_users, :dependent => :destroy, :class_name => 'MessageThreadUser'
    base.has_many :users, :through => :thread_users

    base.scope :message_threads, base.joins(:messages).group('message_threads.id').order("updated_at DESC")

    base.extend(ClassMethods)
  end

  module ClassMethods
    
    def find_or_create_by_user_ids(*user_ids)
      thread = find_or_initialize_by_user_ids(user_ids)
      thread.save
      thread
    end
    
    def find_or_initialize_by_user_ids(*user_ids)
      user_ids = user_ids.flatten.uniq
      existing_threads = MessageThread.scoped
      user_ids.each_with_index do |user_id,idx|
        existing_threads = existing_threads.joins("INNER JOIN message_thread_users AS tp#{idx} ON tp#{idx}.message_thread_id = message_threads.id AND tp#{idx}.user_id = #{user_id}").readonly(false)
      end
      existing_threads.reject!{|t| t.user_ids.sort != user_ids.sort}
      existing_threads.first || new(:user_ids => user_ids)
    end
    
  end
  
  def last_message
    messages.last
  end
  
  def last_message_for(user)
   messages.last
  end
  
  def set_read!(user)
    thread_users.where(:user_id => user.id).first.set_read!
  end

  def set_unread!(user)
    thread_users.where(:user_id => user.id).first.set_unread!
  end

  def is_unread?(user)
    !thread_users.where(:user_id => user.id).first.read?
  end
  
  def user_for_last_message(current_user)
    if messages.last.user == current_user
      if (thread_user = thread_users.where("user_id <> ?", current_user.id).first)
        thread_user.user
      else
        last_message_for(current_user).user
      end
    else
      last_message_for(current_user).user
    end
  end

  
end
