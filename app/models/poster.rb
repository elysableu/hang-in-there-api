# Koiree: This is the Poster model, defining the schema and validations for the posters table.

class Poster < ApplicationRecord
# Validations for the Poster model

# Ensure that the 'name' attribute is present and unique
validates :name, presence: true, uniqueness: { case_sensitive: false }

# Ensure that the 'description' attribute is present and not empty
validates :description, presence: true

# Ensure that 'price' is:
# - Present (cannot be nil)
# - A number greater than or equal to 0 (posters cannot have negative prices)
validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

# Ensure that 'year' is:
# - Present (cannot be nil)
# - An integer value
validates :year, presence: true, numericality: { only_integer: true }

# Ensure that 'vintage' is present and either true or false
validates :vintage, inclusion: { in: [true, false] }

# Ensure that 'img_url' is present and a valid format
validates :img_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
end