module NotificationsHelper
  def notification_form(notification)
    case notification.action
    when "follow"
      tag.a(notification.visiter.name, href: user_path(notification.visiter)) + "さんがあなたをフォローしました"
    when "favorite"
      tag.a(notification.visiter.name, href: user_path(notification.visiter)) + "さんが" +
      tag.a('あなたの投稿', href: post_path(notification.post_id)) + "にいいねしました"
    when "comment"
      tag.a(notification.visiter.name, href: user_path(notification.visiter)) + "さんが" +
      tag.a('あなたの投稿', href: post_path(notification.post_id)) + "にコメントしました"
    end
  end

  def unchecked_notifications
    current_user.passive_notifications.where(checked: false)
  end
end
