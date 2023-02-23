# frozen_string_literal: true

class ShortenUrl < ApplicationRecord
  ALIAS_LENGTH = 8
  ALIAS_PADDING = '0'
  HOST = ENV['HOST'] || 'https://short.est' # our host

  validates :original_url, presence: true
  validates :user_id, presence: true

  def self.format_alias(string)
    string.rjust(ALIAS_LENGTH, ALIAS_PADDING)
  end

  def as_json(options = {})
    super.merge!(alias: alias_with_host)
  end

  def alias_with_host
    File.join(HOST, self.alias)
  end
end
