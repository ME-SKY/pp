class AttachmentsController < ApplicationController
  # respond_to :json

  def index

  end

  def new
  end

  def create
    # p "params: #{ params }"
    @attachment = Attachment.create(file: params[:files]['0'])
    render json: @attachment
    # respond_to do |format|
    #   if @attachment.save
    #     redirect_to action: :show
        # format.html { render @attachment}
        # format.json { render :show, status: :created, location: @attachment }
      # else
      #   p "error"
        # format.html { render :new }
        # format.json { render json: @post.errors, status: :unprocessable_entity }
      # end
    # end
    # head :ok
  end

  def show
    render json: @attachment
  end

  def edit
  end

  def update
  end

  def destroy
  end
end