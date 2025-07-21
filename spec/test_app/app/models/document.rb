class Document < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
