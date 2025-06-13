require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      it 'successfully render' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:html]
      end
    end

    context 'when user not logged in' do
      it 'redirects to login page' do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
