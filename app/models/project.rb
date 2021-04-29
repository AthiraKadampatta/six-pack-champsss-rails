class Project < ApplicationRecord
  attribute :points_per_hour, default: 20

  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true
  validates :name,  length: { minimum: 3 }
  validates :points_per_hour, numericality: { greater_than: 0 }
end
