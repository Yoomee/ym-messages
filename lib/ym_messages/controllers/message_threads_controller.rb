module YmMessages::MessageThreadsController

  def self.included(base)
    base.load_and_authorize_resource
  end
  
  def all
    @message_threads = MessageThread.order('updated_at DESC').paginate(:per_page => 50, :page => params[:page])
  end

  def index
    @message_threads = current_user.threads.order('updated_at DESC').paginate(:per_page => 50, :page => params[:page])
  end
  
  def show
    @message_thread.set_read!(current_user)
    @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
    @last_message = @messages.first
  end

end