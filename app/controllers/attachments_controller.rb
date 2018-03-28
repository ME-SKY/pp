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
    # head :ok
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end