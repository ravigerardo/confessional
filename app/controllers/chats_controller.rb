class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_and_public_user_id, only: %i[ show destroy message ]

  def index
    @chats = Chat.for_home(current_user.id)
  end

  def show
    unauthorized unless current_user.in_chat? @chat
  end

  def create
    @chat = current_user.chats.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chat_url(@chat.uid), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def message
    unauthorized unless current_user.in_chat? @chat
    
    @message = @chat.messages.new(value: params[:message], user_id: current_user.id)
    if @message.save
      ActionCable.server.broadcast("chat_#{@chat.uid}", { message: @message.value, public_user_id: @public_user_id })
      render json: { message: @message.value }, status: :created
    else
      render json: { message: @message.error }, status: :unprocessable_entity
    end
  end

  private
    def set_chat_and_public_user_id
      @chat = Chat.find_by(uid: params[:uid])
      @public_user_id = (current_user.id.to_s+@chat.uid.to_s).crypt("$rounds=1000$salt$")
    end

    def chat_params
      params.require(:chat).permit(:name, :to_id)
    end
end
