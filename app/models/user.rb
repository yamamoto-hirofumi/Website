class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship",
                                      foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship",
                           foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :user_rooms, dependent: :destroy
  has_many :chats
  has_many :active_notifications, class_name: "Notification",
                                  foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key: "visited_id", dependent: :destroy
  has_many :login_histories, dependent: :destroy
  attachment :profile_image

 
  validates :introduction, length: { maximum: 100 }

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # フォローされた時の通知
  def create_notification_follow!(current_user)
    temp = current_user.active_notifications.where(visited_id: id, action: "follow")
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id, action: "follow"
      )
      notification.save if notification.valid?
    end
  end
end
