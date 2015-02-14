require 'rails_helper'

RSpec.describe Post, :type => :model do
  describe "passing :author_name" do
    let(:category) {
      Category.create name: 'just category'
    }

    describe "when author doesn't exist" do
      it "should automatically create author" do
        expect {
          Post.create(title: "just post", category: category, author_name: 'Matz')
        }.to change(Author, :count).by(1)
        expect(Author.last.name).to eq("Matz")
      end
    end
  end

  describe "passing :category_name" do
    let(:author) {
      Author.create name: 'Matz'
    }

    describe "when author doesn't exist" do
      it "should automatically create author" do
        expect {
          Post.create(title: "just post", author: author, category_name: 'programming')
        }.to change(Category, :count).by(1)
        expect(Category.last.name).to eq('programming')
      end
    end
  end

  describe "with_best_authors" do
    let(:benjamin) { Author.create name: "Benjamin Pierce" }
    let(:matz)     { Author.create name: "Matz" }
    let(:medvedev) { Author.create name: "Dmitriy Medvedev" }
    before {
      10.times do # create 50 records, but only 40 of them are with best authors
        Post.create title: "post about ruby!",
                    author: matz,
                    category_name: 'programming',
                    rating: 3
        Post.create title: "post about ruby!",
                    author: matz,
                    category_name: 'programming',
                    rating: 2
        Post.create title: "post about type theory!",
                    author: benjamin,
                    category_name: 'programming',
                    rating: 4
        Post.create title: "post about type theory!",
                    author: benjamin,
                    category_name: 'programming',
                    rating: 1
        Post.create title: "i don't know anything about programming :(",
                    author: medvedev,
                    category_name: 'programming',
                    rating: rand(1..2)
      end
    }
    let(:posts) {
      Post.with_best_authors
    }

    it "should work properly" do
      expect(posts.count).to eq(40)
      expect(posts.flat_map(&:author).uniq).to contain_exactly(matz, benjamin)
    end
  end
end
