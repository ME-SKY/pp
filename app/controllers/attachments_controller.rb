class AttachmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # respond_to :json

  def index

  end

  def new
  end

  def create
    @attachment = Attachment.create(file: params['upload'])
    # url = @attachment.file
    # attachment_json = {uploaded: true, @attachment}.to_json
    atjson = {uploaded: true, url:  @attachment.file.url}.to_json
    render json: atjson
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