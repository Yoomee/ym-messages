module YmMessages::Message

  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :thread, :class_name => 'MessageThread', :foreign_key => :message_thread_id, :touch => true
    base.belongs_to :user

    base.send(:attr_accessor, :recipient_ids)

    base.before_save :set_thread
    base.after_create :send_emails

    base.validates :text, :presence => true

    base.extend(ClassMethods)
  end

  module ClassMethods
    def valid_recipients_for_user(user)
      return [] if user.no_private_messaging?
      User.without(user).where(:no_private_messaging => false)
    end
  end

  private
  def send_emails
    thread.users.where('user_id != ?', user.id).each do |user|
      thread.set_unread!(user)
      YmMessages::UserMailer.new_message(self, user).deliver if user.email_for_new_message?
    end
  end

  def set_thread
    if thread.nil?
      self.thread = MessageThread.find_or_create_by_user_ids(user_id, recipient_ids.map(&:to_i))
      thread.set_read!(user)
    end
  end

end