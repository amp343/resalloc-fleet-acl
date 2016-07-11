class AddUser < ActiveRecord::Migration[5.0]
  def change
    User.create do |u|
      u.email     = "you@email.com"
      u.password  = "password"
    end

    User.create do |u|
      u.email     = "someone.else@email.com"
      u.password  = "otherpassword"
    end

    User.create do |u|
      u.email     = "someone.else2@email.com"
      u.password  = "otherpassword"
    end
  end
end
