class Project < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true
  validates :name,  length: { minimum: 3 }
end
