# Koiree: This RSpec test checks model validations for the Poster model.

require 'rails_helper'

RSpec.describe Poster, type: :model do
  describe 'validations' do
    subject do
      Poster.new(
        name: "Developer Mental Struggle", 
        description: "My code is & is not working and I don't know why", 
        price: 15.99, 
        year: 2023, 
        vintage: true, 
        img_url: "https://gist.github.com/user-attachments/assets/b43aa61c-d674-44c7-a29e-7b72d086b3b1"
      )
    end

    # Presence Validations
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:img_url) }

    # Uniqueness Validation (Case Insensitive)
    it "validates uniqueness of name (case-insensitive)" do
      Poster.create!(
        name: "Sample Poster", 
        description: "Another Description", 
        price: 10.00, 
        year: 2020, 
        vintage: false, 
        img_url: "https://gist.github.com/user-attachments/assets/b43aa61c-d674-44c7-a29e-7b72d086b3b1"
      )
      expect(subject).to validate_uniqueness_of(:name).case_insensitive
    end

    # Numericality Validations
    it "validates numericality of price" do
      subject.price = -1
      expect(subject).not_to be_valid
      expect(subject.errors[:price]).to include("must be greater than or equal to 0")

      subject.price = 0
      expect(subject).to be_valid

      subject.price = 15.99
      expect(subject).to be_valid
    end

    it "validates numericality of year" do
      subject.year = "Not a number"
      expect(subject).not_to be_valid
      expect(subject.errors[:year]).to include("is not a number")

      subject.year = 2023
      expect(subject).to be_valid
    end

    # Boolean Inclusion Validation
    it { should validate_inclusion_of(:vintage).in_array([true, false]) }

    # Format Validation
    it "validates format of img_url" do
      subject.img_url = "invalid_url"
      expect(subject).not_to be_valid
      expect(subject.errors[:img_url]).to include("must be a valid URL")

      subject.img_url = "https://gist.github.com/user-attachments/assets/b43aa61c-d674-44c7-a29e-7b72d086b3b1"
      expect(subject).to be_valid
    end
  end
end