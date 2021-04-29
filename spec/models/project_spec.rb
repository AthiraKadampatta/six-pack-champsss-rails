require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validations' do
    context 'invalid' do
      it 'when name less than 3 characters' do
        project = Project.new(name: 'aa')
        expect(project.valid?).to be false
      end

      it 'when name is nil' do
        project = Project.new(name: nil)
        expect(project.valid?).to be false
      end
    end

    context 'valid' do
      it 'when name with 3 characters' do
        project = Project.new(name: 'KFC')
        expect(project.valid?).to be true
      end

      it 'when name with more than 3 characters' do
        project = Project.new(name: 'Test Project 3')
        expect(project.valid?).to be true
      end
    end
  end
end
