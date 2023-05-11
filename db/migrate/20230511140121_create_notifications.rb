class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string       :message
      t.references   :user
      t.references   :notificationable, polymorphic: true

      t.timestamps
    end
  end
end
