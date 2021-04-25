require "rails_helper"

RSpec.describe User, :type => :model do
  it 'assigns default role' do
    user = User.new(email: 'test@email.com')
    expect(user.role).to eq 'associate'
  end

  context 'when name is not passed' do
    it 'sets default name from email' do
      user = User.create(email: 'test.user@email.com')
      expect(user.name).to eq 'Test.User'
    end
  end

  context 'when name is passed' do
    it 'sets the passed name' do
      user = User.create(email: 'test.user@email.com', name: 'ABC')
      expect(user.name).to eq 'ABC'
    end
  end
end