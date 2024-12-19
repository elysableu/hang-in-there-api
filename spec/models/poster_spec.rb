#Koiree: This RSpec test checks model validations for the Poster model.

require 'rails_helper'

RSpec.describe Poster, type: :model do
  # Describe the context of validations for the Poster model
  describe 'validations' do

    # Check that a Poster must have a name
    it { should validate_presence_of(:name) }

    # Check that a Poster must have a description
    it { should validate_presence_of(:description) }

    # Ensure the price field is present
    it { should validate_presence_of(:price) }

    # Validate that the price must be a number and greater than zero
    it { should validate_numericality_of(:price).is_greater_than(0) }

    # Ensure the year field is present
    it { should validate_presence_of(:year) }
  end
end