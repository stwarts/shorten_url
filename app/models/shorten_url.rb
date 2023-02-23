# frozen_string_literal: true

class ShortenUrl < ApplicationRecord
  ALIAS_LENGTH = 8
  ALIAS_PADDING = '0'

  validates :original_url, presence: true
  validates :user_id, presence: true

  def self.format_alias(string)
    string.rjust(ALIAS_LENGTH, ALIAS_PADDING)
  end
end
