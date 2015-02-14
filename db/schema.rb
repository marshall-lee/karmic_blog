# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150214182412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.text     "name",               null: false, index: {name: "index_authors_on_name", unique: true}
    t.integer  "posts_count",        default: 0, null: false
    t.integer  "rating_numerator",   default: 0, null: false
    t.integer  "rating_denominator", default: 1, null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index name: "index_authors_on_rating", expression: "div((rating_numerator)::numeric, (rating_denominator)::numeric)"
  end

  create_table "categories", force: :cascade do |t|
    t.text     "name",        null: false, index: {name: "index_categories_on_name", unique: true}
    t.integer  "posts_count", default: 0, null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "title",       null: false
    t.text     "body"
    t.integer  "category_id", index: {name: "index_posts_on_category_id"}
    t.integer  "author_id",   index: {name: "index_posts_on_author_id"}
    t.integer  "rating",      null: false, index: {name: "index_posts_on_rating"}
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "posts", "authors"
  add_foreign_key "posts", "categories"
end
