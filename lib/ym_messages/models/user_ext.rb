module YmMessages::UserExt
  
  def self.included(base)
    base.has_many(:thread_users, :class_name => 'MessageThreadUser', :foreign_key => :user_id, :dependent => :destroy)
    base.has_many(:threads, :through => :thread_users, :source => :message_thread, :uniq => true)
    base.has_many(:messages, :dependent => :destroy)
  end

end