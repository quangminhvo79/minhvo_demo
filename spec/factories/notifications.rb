FactoryBot.define do
  factory :notification do
    user
    notificationable { create(:video) }
  end
end
