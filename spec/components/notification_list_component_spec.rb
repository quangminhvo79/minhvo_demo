# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotificationListComponent, type: :component do
  let(:video) { build :video, creator: current_user }
  let!(:notification) { create :notification, user: current_user, message: 'This is message for current user', notificationable: video }
  let!(:notification_other) { create :notification, user: other, message: 'This is message for other user', notificationable: video }
  let(:current_user) { create :user }
  let(:other) { create :user }

  context 'when user not logged-in' do
    it 'returns notthing' do
      Current.current_user = nil
      render_inline(described_class.new(user: current_user))

      expect(page.text).to eq ''
    end
  end

  context 'when user is logged-in' do
    before do
      Current.current_user = current_user
    end

    context 'when given specific user' do
      it 'returns notifications of given user' do
        subject = described_class.new(user: other)
        render_inline(subject)
        expect(subject.notifications).to eq [notification_other]
        expect(page).to have_selector('div.notification-item', text: 'This is message for other user')
      end
    end

    context 'when not given specific user' do
      it 'returns notifications of given user' do
        subject = described_class.new
        render_inline(subject)

        expect(subject.notifications).to eq [notification]
        expect(page).to have_selector('div.notification-item', text: 'This is message for current user')
      end
    end
  end
end
