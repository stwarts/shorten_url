# frozen_string_literal: true

class ShortenUrlEncoding
  class Error < StandardError; end
  class DecodeError < StandardError; end

  KEYS = ('0'..'9').to_a + ('a'..'z').to_a
  BASE = KEYS.size
  VALUE_MAPPER = KEYS.zip(0..BASE).to_h

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

  def self.decode(encoded_string)
    encoded_string.reverse.each_char.with_index.sum do |digit, power|
      digit_value = VALUE_MAPPER[digit]

      raise DecodeError, "Invalid digit: #{digit}" if digit_value.nil?

      digit_value * (BASE**power)
    end
  end
end
