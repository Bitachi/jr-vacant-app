class NotificationSub < Notification
  def self.notify
    notifications = NotificationSub.all

    notifications.each do |notification|
      #notification.token  = notification.get_token(password)
      system("python3 main.py #{notification.month} #{notification.day} #{notification.hour} #{notification.minute} #{notification.train} #{notification.dep_stn} #{notification.arr_stn} #{notification.get_token}")
    end
  end
  NotificationSub.notify
end
