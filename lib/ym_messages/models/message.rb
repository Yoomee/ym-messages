module YmMessages::Message

  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :thread, :class_name => 'MessageThread', :foreign_key => :message_thread_id, :validate => true, :touch => true
    base.belongs_to :user

    base.send(:attr_accessor, :recipient_ids)

    base.before_validation :set_thread, :on => :create
    base.before_create :read_thread!
    base.after_create :send_emails

    base.validates :text, :thread, :user, :presence => true

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
      YmMessages::MessageMailer.new_message(self, user).deliver if user.email_for_new_message?
    end
  end

  def set_thread
    if user_id.present? && recipient_ids.present?
      self.thread ||= MessageThread.find_or_initialize_by_user_ids(user_id, recipient_ids.reject(&:blank?).map(&:to_i))
    end
  end
  
  def read_thread!
    thread.save if thread.new_record?
    thread.set_read!(user)
  end

end