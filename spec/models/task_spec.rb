require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  context 'when is new' do
    it { expect(task).not_to be_done }
  end

  it { expect(task).to belong_to(:user) }

  it { expect(task).to validate_presence_of :title }
  it { expect(task).to validate_presence_of :user_id }
  
  it { expect(task).to respond_to(:title) }
  it { expect(task).to respond_to(:description) }
  it { expect(task).to respond_to(:deadline) }
  it { expect(task).to respond_to(:done) }
  it { expect(task).to respond_to(:user_id) }
end
