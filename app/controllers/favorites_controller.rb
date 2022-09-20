class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorites = @post.favorites.new(user_id: current_user.id)
    favorites.save
    @post.create_notification_favorite!(current_user)
    @favorites = Favorite.where(post_id: params[:post_id])
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorites = @post.favorites.find_by(user_id: current_user.id)
    favorites.destroy
    @favorites = Favorite.where(post_id: params[:post_id])
  end
end
