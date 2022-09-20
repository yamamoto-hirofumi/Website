class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @tags = Tag.all
    @tag_ranks = Tag.tag_ranking
    @keyword = params[:keyword]
    @tag = params[:tag]
    @sort_keyword = params[:sort_keyword]
    if @keyword # キーワード検索時
      @posts = Post.where(["title like? OR content like?", "%#{@keyword}%", "%#{@keyword}%"]).
        order(created_at: :desc).page(params[:page]).per(10)
    elsif @sort_keyword # ソート時
      @posts = Post.sort(@sort_keyword).page(params[:page]).per(10)
    elsif @tag # タグ検索時
      @posts = Post.where(id: Tag.find_by(name: @tag).posts.ids).
        order(created_at: :desc).page(params[:page]).per(10)
    else # 通常時
      @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = PostComment.new
    @favorites = Favorite.where(post_id: @post.id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag_ids].split(",")
    if tag_list.present? && @post.save
      @post.save_tags(tag_list)
      flash[:notice] = "投稿成功しました"
      redirect_to posts_path
    else
      flash[:error] = "タグを入れてください"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(",")
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_ids].split(",")
    if tag_list.present? && @post.update(post_params)
      @post.save_tags(tag_list)
      flash[:notice] = "更新できました"
      redirect_to post_path(@post)
    else
      flash[:error] = "タグを入れてください"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "削除に成功しました"
      redirect_to posts_path
    else
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :title, :content)
  end
end
