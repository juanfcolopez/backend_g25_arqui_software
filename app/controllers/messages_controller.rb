class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat
  def create
    @message = @chat.messages.new(message_params)
    @message.user = current_user
    @message.save
    redirect_back(fallback_location: root_path)
  end

  private

  def message_params
    params.require(:message).permit(:body, :chat_id)
  end

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end
end
