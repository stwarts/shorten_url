# frozen_string_literal: true

class ShortenUrl::EncodeService
  attr_reader :original_url,
              :user_id

  def initialize(original_url:, user_id:)
    @original_url = original_url
    @user_id = user_id
  end

  def call
    # It's unnecessary to add index to original_url as the query will leverage index on column user_id
    found_record = ShortenUrl.find_by(original_url:, user_id:)
    return found_record if found_record

    record = ShortenUrl.create!(original_url:, user_id:)

    encoded_string = ::ShortenUrlEncoding.encode(record.id)
    zero_padded_alias = ShortenUrl.format_alias(encoded_string)

    # TODOL handle StatementInvalid
    record.update_columns(alias: zero_padded_alias)

    record
  rescue ActiveRecord::RecordInvalid => e
    e.record
  end
end
