class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[ show destroy ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.with_user(current_user.id)
  end
  
  # GET /chats/1 or /chats/1.json
  def show
    unauthorized unless current_user.in_chat? @chat
    ActionCable.server.broadcast("chat_#{@chat.uid}", { body: "This Room is Best Room." })
  end

  # POST /chats or /chats.json
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

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by(uid: params[:uid])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:name, :to_id)
    end
end
