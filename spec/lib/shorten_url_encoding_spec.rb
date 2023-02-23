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

  describe '.decode' do
    it 'decodes correctly' do
      expect(described_class.decode('3f')).to eq(123)
    end

    context 'with zero' do
      it 'decodes correctly' do
        expect(described_class.decode('0')).to eq(0)
      end
    end

    context 'with extremely large number' do
      it 'decodes correctly' do
        expect(described_class.decode('zzzzzzzz')).to eq((36**8) - 1)
        expect(described_class.decode('zq0ao')).to eq(60_000_000)
      end
    end

    context 'when number is out of range' do
      it 'decodes correctly' do
        expect(described_class.decode('100000000')).to eq(36**8)
        expect(described_class.decode('100000001')).to eq((36**8) + 1)
        expect(described_class.decode('largenumber')).to eq(77_872_382_519_237_955)
      end
    end

    context 'when exist a digit out of range' do
      it 'raise error' do
        expect { described_class.decode('A') }.to raise_error(ShortenUrlEncoding::DecodeError, 'Invalid digit: A')
        expect { described_class.decode('Z') }.to raise_error(ShortenUrlEncoding::DecodeError, 'Invalid digit: Z')
        expect { described_class.decode('1@') }.to raise_error(ShortenUrlEncoding::DecodeError, 'Invalid digit: @')
        expect { described_class.decode('1$') }.to raise_error(ShortenUrlEncoding::DecodeError, 'Invalid digit: $')
      end
    end
  end
end
