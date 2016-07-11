class Resource < ApplicationRecord

  include ActionView::Helpers::DateHelper

  belongs_to :user, optional: true

  scope :leased, -> { where("user_id IS NOT NULL") }
  scope :leased_to_user, -> (user) { where(user_id: user.id) }

  def lease_to_user(user)
    self.user = user
    self.leased_at = DateTime.now
    self.leased_until = DateTime.now + 2.hours
    self.save
  end

  def unlease
    self.user_id = nil
    self.leased_until = nil
    self.save
  end

  def lease_duration
    seconds = self.leased_until.to_datetime.to_i - self.leased_at.to_datetime.to_i
    hms = Time.at(seconds).utc.strftime("%H:%M:%S")
    hms
  end

  def lease_remaining
    if self.is_leased? && self.leased_until.present?
      seconds = self.leased_until.to_datetime.to_i - DateTime.now.to_i
      if seconds > 0
        hms = Time.at(seconds).utc.strftime("%H:%M:%S")
      end
    else
      hms = "00:00:00"
    end

    hms
  end

  def self.check_lease_expiration
    logger.info 'checking lease expiration...'

    leased = self.leased

    logger.info 'currently leased servers'
    logger.info leased

    leased.each do |lease|
      if DateTime.now > lease.leased_until.to_datetime
        logger.info 'unleasing:'
        lease.unlease
      end
    end
  end

  def is_leased?
    !self.user_id.nil?
  end

  def is_leased_to_user?(user)
    self.user_id == user.id
  end
end
