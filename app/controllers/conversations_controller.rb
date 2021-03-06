class ConversationsController < ApplicationController
  before_action :authenticate_user!, except: [:notify]

  def index
    @users = User.all
    @conversations = Conversation.involving(current_user)
    @conversations.each do |conversation|
      if !conversation.messages.last
        conversation.destroy
      end
    end
    @conversations = Conversation.involving(current_user)
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create(conversation_params)
    end

    redirect_to conversation_messages_path(@conversation)
  end

  def destroy
    @conversation.destroy
  end

  private

    def conversation_params
      params.permit(:sender_id, :recipient_id, :booking)
    end

end
