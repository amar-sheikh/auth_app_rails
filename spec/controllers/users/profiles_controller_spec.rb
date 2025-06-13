require 'rails_helper'

RSpec.describe Users::ProfilesController, type: :controller do
  describe '#edit' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      it 'successfully render' do
        get :edit
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:html]
      end
    end

    context 'when user not logged in' do
      it 'redirects to login page' do
        get :edit
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user, email: 'old_email@gmail.com', password: 'old_password', confirmed_at: '2025-06-10 10:00:00') }

    context 'when user logged in' do

      before do
        sign_in(user)
      end

      it 'successfully update user and send confirmation mail' do
        expect(ActionMailer::Base.deliveries.first).to be_nil

        expect(user).to have_attributes(
            email: 'old_email@gmail.com',
            password: 'old_password',
            confirmed_at: Time.zone.parse('2025-06-10 10:00:00')
        )

        patch :update, params: {
          user: {
            email: 'new_email@gmail.com',
            current_password:'old_password',
            password: 'new_password',
            password_confirmation: 'new_password'
          }
        }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
        expect(assigns(:user)).to have_attributes(
            email: 'old_email@gmail.com',
            confirmed_at: nil
        )
        expect(assigns(:user).valid_password?('new_password')).to be_truthy
        expect(ActionMailer::Base.deliveries.first).to be_present
        expect(ActionMailer::Base.deliveries.first.to).to include 'new_email@gmail.com'
        expect(ActionMailer::Base.deliveries.first.subject).to eq 'Confirmation instructions'
      end

      context 'when current password is invalid' do
        it 'renders with error' do
          expect(ActionMailer::Base.deliveries.first).to be_nil

          patch :update, params: {
            user: {
              email: 'old_email@gmail.com',
              current_password:'invalid_password',
              password: 'new_password',
              password_confirmation: 'new_password'
            }
          }

          expect(response).to have_http_status(:ok)
          expect(assigns(:user).errors.full_messages).to include 'Current password is invalid'
          expect(ActionMailer::Base.deliveries.first).to be_nil
        end
      end

      context 'when new passwords not matched' do
        it 'renders with error' do
          expect(ActionMailer::Base.deliveries.first).to be_nil

          patch :update, params: {
            user: {
              email: 'old_email@gmail.com',
              current_password:'old_password',
              password: 'new_password1',
              password_confirmation: 'new_password2'
            }
          }

          expect(response).to have_http_status(:ok)
          expect(assigns(:user).errors.full_messages).to include "Password confirmation doesn't match Password"
          expect(ActionMailer::Base.deliveries.first).to be_nil
        end
      end

      context 'when only password is changed' do
        it 'successfully update user' do
          expect(ActionMailer::Base.deliveries.first).to be_nil

          expect(user).to have_attributes(
              email: 'old_email@gmail.com',
              password: 'old_password',
              confirmed_at: Time.zone.parse('2025-06-10 10:00:00')
          )

          patch :update, params: {
            user: {
              email: 'old_email@gmail.com',
              current_password:'old_password',
              password: 'new_password',
              password_confirmation: 'new_password'
            }
          }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to root_path
          expect(assigns(:user)).to have_attributes(
              email: 'old_email@gmail.com',
              confirmed_at: Time.zone.parse('2025-06-10 10:00:00')
          )
          expect(assigns(:user).valid_password?('new_password')).to be_truthy
          expect(ActionMailer::Base.deliveries.first).to be_nil
        end
      end

      context 'when only email is changed' do
        it 'successfully update user and send confirmation mail' do
          expect(user).to have_attributes(
              email: 'old_email@gmail.com',
              confirmed_at: Time.zone.parse('2025-06-10 10:00:00')
          )
          expect(ActionMailer::Base.deliveries.first).to be_nil

          patch :update, params: {
            user: {
              email: 'new_email@gmail.com',
              current_password:'',
              password: '',
              password_confirmation: ''
            }
          }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to root_path
          expect(assigns(:user)).to have_attributes(
              email: 'old_email@gmail.com',
              confirmed_at: nil
          )
          expect(ActionMailer::Base.deliveries.first).to be_present
          expect(ActionMailer::Base.deliveries.first.to).to include 'new_email@gmail.com'
          expect(ActionMailer::Base.deliveries.first.subject).to eq 'Confirmation instructions'
        end
      end
    end

    context 'when user not logged in' do
      it 'redirect to login page' do
        patch :update, params: {
          user: {
            email: 'new_email@gmail.com',
            current_password:'old_password',
            password: 'new_password',
            password_confirmation: 'new_password'
          }
        }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
