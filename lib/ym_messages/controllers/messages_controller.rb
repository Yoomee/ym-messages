module YmMessages::MessagesController

  def self.included(base)
    base.load_and_authorize_resource :except => :update_settings
  end
  
  def create
    @message.user = current_user
    if @message.save
      flash[:notice] = 'Your message has been sent'
      redirect_to @message.thread
    elsif @message.thread
      @message_thread = @message.thread
      @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page]).reverse
      @last_message = @messages.last
      render :template => 'message_threads/show'
    else
      render :action => 'new'
    end
  end
  
  def new
    if params[:user_id].present? && recipient = User.find_by_id(params[:user_id])
      thread = MessageThread.find_or_initialize_by_user_ids([current_user.id,recipient.id])
      if !thread.new_record?
        @message_thread = thread
        @message = @message_thread.messages.build
        @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page]).reverse
        @last_message = @messages.last
        render :template => 'message_threads/show'
      else
        @message.recipient_ids = [recipient.id.to_s]
      end
    end
  end

  def update_settings
    @user = User.find(params[:user_id])
    authorize!(:edit, @user)
    @user.update_attributes(params[:user])
  end

end