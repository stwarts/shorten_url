# frozen_string_literal: true

class ShortenUrl::EncodeService
  attr_reader :original_url,
              :user_id

  def initialize(original_url:, user_id:)
    @original_url = original_url
    @user_id = user_id
  end

  def call
    # user can be anonymous
    # TODO: handle RecordInvalid
    record = ShortenUrl.create!(original_url:, user_id:)

    alias_url = ::ShortenUrlEncoding.encode(record.id)
    zero_padded_alias_url = format('%08d', alias_url)

    # TODOL handle StatementInvalid
    record.update_columns(alias: zero_padded_alias_url)

    record
  end
end
