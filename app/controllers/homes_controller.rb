class HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about, :new_guest]

  def top
    @post_favorite_ranks = Post.ranking
  end

  def about
  end
  
  #　ゲストログイン
  def new_guest
    user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲスト"
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to posts_path, notice: "ゲストユーザーとしてログインしました"
  end
end
