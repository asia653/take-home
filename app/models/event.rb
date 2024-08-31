class Event < ApplicationRecord
  validates :name, :location, :start_time, :end_time, presence: true
  belongs_to :user, optional: false
end
