# frozen_string_literal: true

class ShortenUrl::DecodeService
  attr_reader :encoded_url

  def initialize(encoded_url:)
    @encoded_url = encoded_url
  end

  def call
    raise ActiveRecord::RecordNotFound if encoded_url.blank?

    ShortenUrl.find_by!(alias: parsed_alias)
  end

  private

  def parsed_alias
    alias_url = encoded_url.split(ShortenUrl::HOST)[-1]
    alias_url.delete_prefix('/')
  end
end
