require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  describe '#index' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      context 'when user has current address' do
        let!(:address) { create(:address, user: user) }

        it 'successfully render' do
          get :index
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:html]
          expect(assigns(:address)).to be_an_instance_of(Address)
          expect(assigns(:address)).to be_persisted
          expect(assigns(:address)).to eq(address)
        end
      end

      context 'when user does not have current address' do
        it 'successfully render' do
          get :index
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:html]
          expect(assigns(:address)).to be_an_instance_of(Address)
          expect(assigns(:address)).not_to be_persisted
        end
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

  describe '#new' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      context 'when user has current address' do
        let!(:address) { create(:address, user: user) }

        it 'successfully render' do
          get :new
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:html]
          expect(assigns(:address)).to be_an_instance_of(Address)
          expect(assigns(:address)).to be_persisted
          expect(assigns(:address)).to eq(address)
        end

        context 'when user current address have transactions' do
          let!(:address) { create(:address, transactions_count: 1) }

          it 'successfully render' do
            get :new
            expect(response).to have_http_status(:ok)
            expect(response.media_type).to eq Mime[:html]
            expect(assigns(:address)).to be_an_instance_of(Address)
            expect(assigns(:address)).not_to be_persisted
          end
        end
      end

      context 'when user does not have current address' do
        it 'successfully render' do
          get :new
          expect(response).to have_http_status(:ok)
          expect(response.media_type).to eq Mime[:html]
          expect(assigns(:address)).to be_an_instance_of(Address)
          expect(assigns(:address)).not_to be_persisted
        end
      end
    end

    context 'when user not logged in' do
      it 'redirects to login page' do
        get :new
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#create' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      it 'successfully create a new current address' do
        expect {
          put :create, params: {
            address: {
              line1: 'line 1',
              line2: 'line 2',
              city: 'city',
              country: 'country',
              postcode: 'postcode'
            }
          }
        }.to change(Address, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq "Address was successfully saved."
        expect(Address.last).to have_attributes(
          user: user,
          line1: 'line 1',
          line2: 'line 2',
          city: 'city',
          country: 'country',
          postcode: 'postcode'
        )
      end

      context 'when user have current address' do
        let!(:address) { create(:address, user: user, line1: 'old line 1', line2: 'old line 2', city: 'old city', country: 'old country', postcode: 'old postcode code') }

        it 'successfully update current address' do
          expect(address).to have_attributes(
            user: user,
            line1: 'old line 1',
            line2: 'old line 2',
            city: 'old city',
            country: 'old country',
            postcode: 'old postcode code'
          )

          expect {
            put :create, params: {
              address: {
                line1: 'line 1',
                line2: 'line 2',
                city: 'city',
                country: 'country',
                postcode: 'postcode'
              }
            }
          }.not_to change(Address, :count)

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to root_path
          expect(flash[:notice]).to eq "Address was successfully saved."
          expect(assigns(:address)).to have_attributes(
            user: user,
            line1: 'line 1',
            line2: 'line 2',
            city: 'city',
            country: 'country',
            postcode: 'postcode'
          )
        end

        context 'when user current address have transactions' do
          let!(:address) { create(:address, transactions_count: 1) }

          it 'successfully create a new current address' do
            expect {
              put :create, params: {
                address: {
                  line1: 'line 1',
                  line2: 'line 2',
                  city: 'city',
                  country: 'country',
                  postcode: 'postcode'
                }
              }
            }.to change(Address, :count).by(1)

            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to root_path
            expect(flash[:notice]).to eq "Address was successfully saved."
            expect(Address.last).to have_attributes(
              user: user,
              line1: 'line 1',
              line2: 'line 2',
              city: 'city',
              country: 'country',
              postcode: 'postcode'
            )
          end
        end
      end
    end

    context 'when user not logged in' do
      it 'redirect to login page' do
        put :create, params: {
          address: {
            line1: 'line 1',
            line2: 'line 2',
            city: 'city',
            country: 'country',
            postcode: 'postcode'
          }
        }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
