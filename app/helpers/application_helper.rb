module ApplicationHelper
  # ログインカウントに応じ画像変更
  def login_history_image
    if User.find(params[:id]).login_histories.count < 10
      image_tag(asset_path("login_count_image3.jpeg"), size: '100x40')
    elsif User.find(params[:id]).login_histories.count < 20
      image_tag(asset_path("login_count_image2.jpeg"), size: '100x40')
    else
      image_tag(asset_path("login_count_image1.jpeg"), size: '100x40')
    end
  end

  # ソート機能
  def sort_selection
    case params[:sort_keyword]
    when "new"
      "投稿の新しい順"
    when "old"
      "投稿の古い順"
    when "favorites"
      "いいねの多い順"
    when "comments"
      "コメントの多い順"
    end
  end
end
