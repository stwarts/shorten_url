# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortenUrlEncoding do
  describe '.encode' do
    it 'encodes correctly' do
      expect(described_class.encode(123)).to eq('3f')
    end

    context 'with negative number' do
      it 'raises error' do
        expect { described_class.encode(-1) }.to raise_error(ShortenUrlEncoding::Error)
      end
    end

    context 'with zero' do
      it 'encodes correctly' do
        expect(described_class.encode(0)).to eq('0')
      end
    end

    context 'with extremely large number' do
      it 'encodes correctly' do
        expect(described_class.encode((36**8) - 1)).to eq('zzzzzzzz')
        expect(described_class.encode(60_000_000)).to eq('zq0ao')
      end
    end

    context 'when number is out of range' do
      # This will give a longer output (could be more than 8), but does not crash the core functionality
      it 'encodes correcly' do
        expect(described_class.encode(36**8)).to eq('100000000')
        expect(described_class.encode((36**8) + 1)).to eq('100000001')
        expect(described_class.encode(77_872_382_519_237_955)).to eq('largenumber')
      end
    end
  end
end
