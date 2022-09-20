class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])
    @user.create_notification_follow!(current_user)
  end

  def destroy
    current_user.unfollow(params[:user_id])
    @user = User.find(params[:user_id])
  end

  def followings # フォロー一覧
    @user = User.find(params[:user_id])
    @users = @user.followings.order(created_at: :desc).page(params[:page]).per(10)
  end

  def followers # フォロワー一覧
    @user = User.find(params[:user_id])
    @users = @user.followers.order(created_at: :desc).page(params[:page]).per(10)
  end
end
