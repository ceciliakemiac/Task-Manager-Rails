require 'rails_helper'

RSpec.describe User, type: :model do
  # before {@user = FactoryBot.build(:user)}
  # subject { build(:user) }
  let(:user) { build(:user) }

  it { expect(user).to have_many(:task).dependent(:destroy) }

  it { expect(user).to validate_presence_of(:email) }
  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(user).to validate_confirmation_of(:password) }
  it { expect(user).to allow_value('nina@gmail.com').for(:email) }
  it { expect(user).to validate_uniqueness_of(:auth_token) }

  # context "when name is blank" do
  #   before { user.name = "" }

  #   it { expect(user).not_to be_valid }
  # end
  
  # it {expect(user).to respond_to(:email)}
  # it {is_expected.to respond_to(:password)}
  # it {expect(user).to respond_to(:password_confirmation)}
  # it {expect(user).to be_valid}

  describe '#info' do
    it 'returns email and created_at' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('abc123TOKEN')
      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: #{Devise.friendly_token}")
    end
  end

  describe '#generate_auth_token!' do
    it 'before_create will be called' do
      an_user = create(:user)
      expect(an_user.auth_token).not_to be_nil
    end

    it 'generates an unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abc123TOKEN')
      user.generate_auth_token!

      expect(user.auth_token).to eq(Devise.friendly_token)
    end

    it 'generates another auth token when the current auth token has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('abc123TOKEN', 'abc123TOKEN' 'abc456TOKEN')
      another_user = create(:user)
      user.generate_auth_token!

      expect(user.auth_token).not_to eq(another_user.auth_token)
    end
  end
end