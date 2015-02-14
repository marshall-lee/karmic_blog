require 'rails_helper'

RSpec.describe Category, :type => :model do
  describe "find_or_create_unique_by" do
    it "should create new author" do
      expect {
        Category.find_or_create_unique_by(name: 'programming')
      }.to change(Category, :count).by(1)
    end

    it "should not create authors with duplicate names" do
      Category.find_or_create_unique_by(name: 'programming')
      expect {
        Category.find_or_create_unique_by(name: 'programming')
      }.not_to change(Category, :count)
    end
  end

  describe "name_starting_with" do
    let!(:programming) {
      Category.create name: "programming"
    }

    it "should work properly" do
      expect(Category.name_starting_with('progrm')).to eq([])
      expect(Category.name_starting_with('prog')).to eq([programming])
    end
  end
end
