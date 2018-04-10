class PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all.includes(:attachments).order(updated_at: :desc)

    render json: @posts, include: :attachments
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(text: params[:content])
    render json: @post
    # respond_to do |format|
    #   if @post.save
    #     # Attachment.create(file: params[:post][:attachment], post_id: @post.id)
    #     format.html { redirect_to action: :index}
    #     format.json { render :show, status: :created, location: @post }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @post.errors, status: :unprocessable_entity }
    #   end
    # end
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
