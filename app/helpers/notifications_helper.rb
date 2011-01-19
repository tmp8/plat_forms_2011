module NotificationsHelper
  def display_notification(notification)
    subject = notification.subject
    out = "#{notification.created_at} - "
    case subject
    when Conference
      out << "You have ben invited to the conference #{link_to(subject.name, subject)} by #{link_to(notification.user.full_name, notification.user)}"
    else
      notification.class.name
    end
    out.html_safe
  end
end
