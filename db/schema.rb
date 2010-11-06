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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101104213821) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "surname1"
    t.string   "surname2"
    t.text     "description"
    t.integer  "country_id"
    t.string   "email"
    t.string   "web"
    t.string   "cached_slug"
    t.integer  "site_id"
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", :id => false, :force => true do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  add_index "authors_books", ["author_id", "book_id"], :name => "index_authors_books_on_author_id_and_book_id", :unique => true

  create_table "blocks", :force => true do |t|
    t.string   "name"
    t.integer  "layout_id"
    t.integer  "element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "cached_slug"
    t.integer  "site_id"
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.string   "cached_slug"
    t.integer  "site_id"
    t.integer  "num_visits",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                         :default => 0
    t.string   "author"
    t.string   "email"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "value",       :limit => 3
    t.string   "cached_slug"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "critics", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "cached_slug"
    t.integer  "num_visits",  :default => 0
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "critics", ["book_id"], :name => "index_critics_on_book_id"

  create_table "elements", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.integer  "published"
    t.datetime "init_date"
    t.datetime "finish_date"
    t.string   "cached_slug"
    t.integer  "num_visits",     :default => 0
    t.integer  "site_id"
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "cached_slug"
    t.integer  "site_id"
    t.boolean  "system",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "layouts", :force => true do |t|
    t.string   "name"
    t.text     "head"
    t.text     "body"
    t.integer  "site_id"
    t.integer  "visible",    :default => 1
    t.integer  "base",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "noticias", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean  "published"
    t.string   "cached_slug"
    t.integer  "num_visits",     :default => 0
    t.integer  "site_id"
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.integer  "blog_id"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.boolean  "published"
    t.string   "cached_slug"
    t.integer  "num_visits",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "web"
    t.string "email"
    t.string "address"
    t.string "lang"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "surname1"
    t.string   "surname2"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "site_id"
    t.string   "cached_slug"
    t.boolean  "system",                                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
