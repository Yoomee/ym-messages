module YmMessages::MessageThreadsController

  def self.included(base)
    base.load_and_authorize_resource
    base.before_filter :set_user
  end
  
  def all
    @message_threads = MessageThread.order('updated_at DESC').paginate(:per_page => 50, :page => params[:page])
  end

  def index
    @message_threads = @user.threads.order('updated_at DESC').paginate(:per_page => 50, :page => params[:page])
  end
  
  def show
    @message_thread.set_read!(current_user) if current_user == @user
    @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
    @last_message = @messages.first
  end
  
  private
  def set_user
    if current_user.is_admin? && params[:user_id].present?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end

end