class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  validates :comment, length: { maximum: 50 }, presence: true
  
  # コメントされた時の通知
  def create_notification_comment!(current_user)
    if current_user.id == post.user.id
      check_flag = true
    else
      check_flag = false
    end
    current_user.active_notifications.create!(
      post_id: post.id, post_comment_id: id, visited_id: post.user.id,
      action: "comment", checked: check_flag
    )
  end
end
