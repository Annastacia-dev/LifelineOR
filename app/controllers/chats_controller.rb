class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[show edit update destroy]

  # GET /chats or /chats.json
  def index
    @chats = Chat.none
    return unless current_user.chats.any?

    redirect_to chat_url(current_user.chats.last)
  end

  # GET /chats/1 or /chats/1.json
  def show; end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit; end

  # POST /chats or /chats.json
  def create
    @chat = Chat.new(user_id: current_user.id)
    # @chat.user_id = current_user.id

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chat_url(@chat), notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: 'Chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chat_params
    params.require(:chat).permit(:message)
  end
end
