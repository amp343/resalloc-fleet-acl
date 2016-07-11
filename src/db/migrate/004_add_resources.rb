class AddResources < ActiveRecord::Migration[5.0]
  def change
    resources = [
      { name: 'server1', os: 'linux/alpine' },
      { name: 'server2', os: 'linux/jessie' },
      { name: 'server3', os: 'linux/wheezy' },
      {
        name: 'server4',
        os: 'linux/precise',
        user: User.find_by(email: "someone.else2@email.com"),
        leased_at: DateTime.now,
        leased_until: DateTime.now + 3.minutes
      },
      {
        name: 'server5',
        os: 'linux/trusty',
        user: User.find_by(email: "someone.else@email.com"),
        leased_at: DateTime.now,
        leased_until: DateTime.now + 2.hours
      }
    ]

    resources.each do |resource|
      Resource.create(resource)
    end
  end
end
