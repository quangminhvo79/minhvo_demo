FactoryBot.define do
  factory :video do
    creator { create(:user) }
    title { Faker::Book.title }
    youtube_video_id { SecureRandom.hex(4) }
  end
end
