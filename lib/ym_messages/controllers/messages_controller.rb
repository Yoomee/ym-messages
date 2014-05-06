module YmMessages::MessagesController

  def self.included(base)
    base.load_resource :except => :update_settings
    base.authorize_resource :except => [:update_settings, :create]
  end
  
  def create
    @message.user = current_user
    @message.send(:set_thread)
    authorize!(:create, @message)
    if @message.save
      flash[:notice] = 'Your message has been sent'
      redirect_to @message.thread
    elsif @message.thread.messages.count > 0
      @message_thread = @message.thread
      @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
      @last_message = @messages.first
      render :template => 'message_threads/show'
    else
      render :action => 'new'
    end
  end
  
  def new
    if params[:user_id].present? && recipient = User.find_by_id(params[:user_id])
      @message_thread = MessageThread.find_or_initialize_by_user_ids([current_user.id,recipient.id])
      if !@message_thread.new_record?
        @message = @message_thread.messages.build(:text => params[:text])
        @messages = @message_thread.messages.reorder('messages.created_at DESC').paginate(:per_page => 10, :page => params[:page])
        @last_message = @messages.first
        render :template => 'message_threads/show'
      else
        @message.recipient_ids = [recipient.id.to_s]
        @message.text = params[:text]
      end
      @message.thread = @message_thread
      authorize! :create, @message 
    end
  end

  def update_settings
    @user = User.find(params[:user_id])
    authorize!(:edit, @user)
    @user.update_attributes(params[:user])
  end

end