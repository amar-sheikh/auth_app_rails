require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe '#index' do
    let(:user) { create(:user) }

    context 'when user logged in' do
      before do
        sign_in(user)
      end

      let!(:address) { create(:address, user: user) }
      let!(:transaction_1) { create(:transaction, address: address) }
      let!(:transaction_2) { create(:transaction, address: address) }

      it 'successfully render' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:html]
        expect(assigns(:transactions)).to eq [transaction_1, transaction_2]
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

      let!(:address) { create(:address, user: user) }

      it 'successfully render' do
        get :new
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:html]
        expect(assigns(:transaction)).to be_an_instance_of(Transaction)
        expect(assigns(:transaction)).not_to be_persisted
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
    let!(:address) { create(:address, user: user) }

    context 'when user logged in' do

      before do
        sign_in(user)
      end

      it 'successfully create a new current address' do
        expect {
          put :create, params: {
            transaction: {
              user_id: user.id,
              address_id: address.id,
              idempotency_key: '88877762',
              amount: 2,
              additional_info: 'abc123'
            }
          }
        }.to change(Transaction, :count).by(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to transactions_path
        expect(flash[:notice]).to eq "Transaction was successfully created."
        expect(Transaction.last).to have_attributes(
          user: user,
          address: address,
          idempotency_key: '88877762',
          amount: 2,
          additional_info: 'abc123'
        )
      end
    end

    context 'when user not logged in' do
      it 'redirect to login page' do
        put :create, params: {
          transaction: {
            user_id: user.id,
            address_id: address.id,
            idempotency_key: '88877762',
            amount: 2,
            additional_info: 'abc123'
          }
        }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
