require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many(:addresses) }
    it { should belong_to(:current_address).class_name('Address').optional(true) }
  end

  describe 'validation' do
    context 'with valid data' do
      subject(:user) { build(:user) }

      it "creates user" do
        expect {
          user.save
        }.to change(User, :count).by(1)
      end
    end

    context 'with invalid email' do
      subject(:user) { build(:user, :invalid) }

      it 'returns error' do
        expect {
          user.save
        }.not_to change(User, :count)

        expect(user.errors.full_messages).to include 'Email is invalid'
      end
    end

    context 'without email' do
      subject(:user) { build(:user, email: '') }

      it 'returns error' do
        expect {
          user.save
        }.not_to change(User, :count)

        expect(user.errors.full_messages).to include "Email can't be blank"
      end
    end

    context 'with email already exists' do
      subject(:user) { build(:user, email: 'email@gmail.com') }

      let!(:user_1) { create(:user, email: 'email@gmail.com') }

      it 'returns error' do
        expect {
          user.save
        }.not_to change(User, :count)

        expect(user.errors.full_messages).to include "Email has already been taken"
      end
    end

    context 'without password' do
      subject(:user) { build(:user, password: '') }

      it 'returns error' do
        expect {
          user.save
        }.not_to change(User, :count)

        expect(user.errors.full_messages).to include "Password can't be blank"
      end
    end

    context 'with short password' do
      subject(:user) { build(:user, password: 'abc') }

      it 'returns error' do
        expect {
          user.save
        }.not_to change(User, :count)

        expect(user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
    end
  end
end
