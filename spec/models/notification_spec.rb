require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:notificationable) }
    it { is_expected.to belong_to(:user) }
  end
end
