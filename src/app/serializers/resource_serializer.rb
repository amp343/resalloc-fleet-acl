class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :os, :is_available, :leased_at, :leased_until, :lease_time_remaining, :leased_to_user
  self.root = false

  def lease_time_remaining
    object.lease_remaining
  end

  def leased_to_user
    object.user_id.present? ? User.find(object.user_id).email : nil
  end

  def is_available
    object.user_id.nil?
  end

end
