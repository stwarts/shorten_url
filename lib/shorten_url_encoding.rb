# frozen_string_literal: true

class ShortenUrlEncoding
  class Error < StandardError; end

  KEYS = ('0'..'9').to_a + ('a'..'z').to_a
  BASE = KEYS.size

  def self.encode(number)
    raise Error if number.negative?

    return KEYS[0] if number.zero?

    encoded_string = ''
    while number.positive?
      reminder = number % BASE
      digit = KEYS[reminder]

      encoded_string += digit

      number /= BASE
    end

    encoded_string.reverse
  end
end
