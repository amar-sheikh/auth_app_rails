require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe '#create' do
    before do
     @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'when user logged in' do
      it 'successfully register user and send confirmation mail' do
        expect(ActionMailer::Base.deliveries.first).to be_nil

        expect {
          patch :create, params: {
            user: {
              email: 'email@gmail.com',
              password: 'password',
              password_confirmation: 'password'
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
        expect(User.last).to have_attributes(
            email: 'email@gmail.com',
            confirmed_at: nil
        )
        expect(User.last.valid_password?('password')).to be_truthy

        expect(ActionMailer::Base.deliveries.first).to be_present
        expect(ActionMailer::Base.deliveries.first.to).to include 'email@gmail.com'
        expect(ActionMailer::Base.deliveries.first.subject).to eq 'Confirmation instructions'
      end

      context 'when new passwords not matched' do
        it 'renders with error' do
          expect(ActionMailer::Base.deliveries.first).to be_nil

          expect {
            patch :create, params: {
              user: {
                email: 'email@gmail.com',
                password: 'password1',
                password_confirmation: 'password2'
              }
            }
          }.not_to change(User, :count)

          expect(response).to have_http_status(:unprocessable_content)
          expect(assigns(:user).errors.full_messages).to include "Password confirmation doesn't match Password"
          expect(ActionMailer::Base.deliveries.first).to be_nil
        end
      end

      context 'when a user with email already present' do
        let!(:user) { create(:user, email: 'email@gmail.com') }

        it 'renders with error' do
          expect(ActionMailer::Base.deliveries.first).to be_nil

          expect {
            patch :create, params: {
              user: {
                email: 'email@gmail.com',
                password: 'password',
                password_confirmation: 'password'
              }
            }
          }.not_to change(User, :count)

          expect(response).to have_http_status(:unprocessable_content)
          expect(assigns(:user).errors.full_messages).to include "Email has already been taken"
          expect(ActionMailer::Base.deliveries.first).to be_nil
        end
      end
    end
  end
end
