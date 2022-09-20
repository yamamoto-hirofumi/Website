class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all.order(created_at: :desc).page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to user_path(@user), notice: "ゲストユーザーは編集できません"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "更新できました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to user_path(@user), notice: "ゲストユーザーは削除できません"
    else
      @user.destroy
      flash[:notice] = "ユーザーを削除しました"
      redirect_to root_path
    end
  end

  def withdraw # 退会
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
