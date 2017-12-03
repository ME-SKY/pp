class PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all.order(updated_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(theme: params[:post][:theme], text: params[:post][:text])
    respond_to do |format|
      if @post.save
        format.html { redirect_to action: :index}
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
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