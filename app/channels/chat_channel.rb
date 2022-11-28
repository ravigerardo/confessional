class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:uid]}"
    puts "#"*30
    puts "chat Subscribed #{params[:token]}"
    puts "#"*30
  end
  
  def unsubscribed
    puts "#"*30
    puts "Chat Subscribed"
    puts "#"*30
  end
end