require 'rails_helper'

RSpec.describe Author, :type => :model do
  describe "find_or_create_unique_by" do
    it "should create new author" do
      expect {
        Author.find_or_create_unique_by(name: 'John Doe')
      }.to change(Author, :count).by(1)
    end

    it "should not create authors with duplicate names" do
      Author.find_or_create_unique_by(name: 'John Doe')
      expect {
        Author.find_or_create_unique_by(name: 'John Doe')
      }.not_to change(Author, :count)
    end
  end

  describe "name_starting_with" do
    let!(:matz) {
      Author.create name: "Matsumoto"
    }

    it "should work properly" do
      expect(Author.name_starting_with('Matz')).to eq([])
      expect(Author.name_starting_with('Mats')).to eq([matz])
    end
  end

  describe "rating" do
    let(:author) { Author.create name: 'Yukihiro Matsumoto' }

    it "should equal to zero by default" do
      expect(author.rating).to eq(0)
    end

    context "when having just one post" do
      let!(:post) {
        Post.create title: 'Just post!', author: author, category_name: 'lol', rating: 3
      }

      it "should equal to post's rating" do
        expect(author.rating).to eq(3)
      end
    end

    context "when having more than one post" do
      before do
        Post.create title: 'Just post!', author: author, category_name: 'lol', rating: 5
        Post.create title: 'Just post!', author: author, category_name: 'lol', rating: 3
        Post.create title: 'Just post!', author: author, category_name: 'lol', rating: 2
        Post.create title: 'Just post!', author: author, category_name: 'lol', rating: 0
      end

      it "should equal to arithmetic mean of posts' ratings" do
        expect(author.rating).to eq(2.5) # 10/4 = 5/2 = 2.5
      end
    end
  end

  describe "#order_by_rating" do
    let(:benjamin) { Author.create name: "Benjamin Pierce" }
    let(:matz)     { Author.create name: "Matz" }
    let(:medvedev) { Author.create name: "Dmitriy Medvedev" }
    before {
      10.times do
        Post.create title: "post about ruby!",
                    author: matz,
                    category_name: 'programming',
                    rating: 5
        Post.create title: "post about type theory!",
                    author: benjamin,
                    category_name: 'programming',
                    rating: rand(3..4)
        Post.create title: "i don't know anything about programming :(",
                    author: medvedev,
                    category_name: 'programming',
                    rating: rand(1..2)
      end
    }

    it "should work properly" do
      expect(Author.order_by_rating).to eq([matz, benjamin, medvedev])
    end
  end

  describe "#with_highest_rating" do
    let(:benjamin) { Author.create name: "Benjamin Pierce" }
    let(:matz)     { Author.create name: "Matz" }
    let(:medvedev) { Author.create name: "Dmitriy Medvedev" }
    before {
      Post.create title: "post about ruby!",
                  author: matz,
                  category_name: 'programming',
                  rating: 5
      Post.create title: "post about type theory!",
                  author: benjamin,
                  category_name: 'programming',
                  rating: 5
      Post.create title: "i don't know anything about programming :(",
                  author: medvedev,
                  category_name: 'programming',
                  rating: rand(1..2)
    }

    it "should work properly" do
      expect(Author.with_highest_rating).to contain_exactly(matz, benjamin)
    end
  end
end
