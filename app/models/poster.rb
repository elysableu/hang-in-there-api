# app/models/poster.rb
#Koiree: This is the Poster model, defining the schema and validations for the posters table.

class Poster < ApplicationRecord
  # Validations for the Poster model

  # Ensure that the 'name' attribute is present and not empty
  validates :name, presence: true, uniqueness: true

  # Ensure that the 'description' attribute is present and not empty
  validates :description, presence: true

  # Ensure that 'price' is:
  # - Present (cannot be nil)
  # - A number greater than 0 (posters cannot be free or negative-priced)
  validates :price, presence: true, numericality: { greater_than: 0 }

  # Ensure that the 'year' attribute is present and not empty
  validates :year, presence:
end