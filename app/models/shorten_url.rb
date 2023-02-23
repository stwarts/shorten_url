# frozen_string_literal: true

class ShortenUrl < ApplicationRecord
  validates :original_url, presence: true
end
