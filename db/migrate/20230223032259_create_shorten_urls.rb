# frozen_string_literal: true

class CreateShortenUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :shorten_urls do |t|
      t.string :original_url
      t.string :user_id
      t.string :alias

      t.timestamps
    end
    add_index :shorten_urls, :user_id
    add_index :shorten_urls, :alias
  end
end
