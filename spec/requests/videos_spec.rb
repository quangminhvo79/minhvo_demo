require 'rails_helper'

RSpec.describe "Videos", type: :request do
  let(:user) { create(:user) }
  let!(:video) { create :video, thumbnails: { high: { url: 'link' } } }

  describe 'GET #index' do

    it 'loads videos successfully' do
      get videos_path
      expect(assigns(:videos)).to eq [video]
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    context 'when user not log in yet' do
      it 'redirect to login page' do
        get new_video_path
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when user logged-in' do
      it 'render share video form' do
        sign_in user
        get new_video_path
        expect(response).to render_template :new
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { video: { youtube_url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' } } }
    let(:service) { double('Youtube::VideoCreator', perform: true, errors: double(full_messages: [])) }

    context 'when user not log in yet' do
      it 'redirect to login page' do
        post videos_path, params: valid_params
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when user logged-in' do
      before do
        allow(Youtube::VideoCreator).to receive(:new).and_return(service)
        sign_in user
      end

      context 'when the service performs successfully' do
        it 'creates a new video and loads the videos' do
          expect(service).to receive(:perform)
          post videos_path, params: valid_params, xhr: true
          expect(flash[:notice]).to eq('Share Youtube video successfully')
          expect(assigns[:videos]).to eq [video]
          expect(response).to render_template :create
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when the service fails to perform' do
        let(:error_messages) { 'YouTube URL is not valid' }

        before do
          allow(service).to receive(:perform).and_return(false)
          allow(service).to receive(:error_sentence).and_return(error_messages)
        end

        it 'sets the flash error and does not create a new video' do
          post videos_path, params: valid_params, xhr: true
          expect(flash[:error]).to eq(error_messages)
          expect(assigns[:videos]).to eq nil
          expect(response).to render_template :create
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
