module RSpec
  module Support
    module Integration
      def login(user)
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: '12345678'
        click_on 'Login'
        expect(page).to have_content('Signed in successfully.')
      end
    end
  end
end
