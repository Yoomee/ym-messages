module YmMessages::MessageThreadsController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def index
    @message_threads = current_user.threads.paginate(:per_page => 50, :page => params[:page])
  end
  
  def show
    @message_thread.set_read!(current_user)
    @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
    @messages = @messages.reverse
    @last_message = @messages.last
  end

end