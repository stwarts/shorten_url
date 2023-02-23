# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortenUrl::EncodeService, aggregate_failures: true do
  let(:service) { described_class.new(original_url:, user_id:) }
  let(:original_url) { 'https://example.com' }
  let(:user_id) { 'user_id' }

  describe '#call' do
    it 'creates a record of shorten_url' do
      expect { @created_record = service.call }.to change { ShortenUrl.count }.by(1)
      @created_record = ShortenUrl.last

      expect(@created_record.original_url).to eq('https://example.com')
      expect(@created_record.alias).not_to be_empty
      expect(@created_record.alias.size).to eq(8)
    end

    context 'when original_url is blank' do
      let(:original_url) { nil }

      it 'has error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid, /Original url can't be blank/)
      end

      it 'does not create new record' do
        expect do
          service.call
        rescue StandardError
          nil
        end.not_to change { ShortenUrl.count }
      end
    end

    context "when the encoded length is less than #{ShortenUrl::ALIAS_LENGTH}" do
      before do
        allow(ShortenUrlEncoding).to receive(:encode).and_return('a')
      end

      it 'paddings to cover missing digits' do
        created_record = service.call
        expect(created_record.alias).to eq('0000000a')
      end
    end

    context "when the encoded length is higher than #{ShortenUrl::ALIAS_LENGTH}" do
      before do
        allow(ShortenUrlEncoding).to receive(:encode).and_return('1234567890')
      end

      it 'stores correcly' do
        created_record = service.call
        expect(created_record.alias).to eq('1234567890')
      end
    end

    context 'when 2 users with 2 identical input URLs' do
      let!(:existing_shorten_url) { ShortenUrl.create!(original_url:, user_id: the_other_user) }
      let(:the_other_user) { SecureRandom.uuid }

      it 'creates different record' do
        expect { @record = service.call }.to change { ShortenUrl.count }.by(1)

        expect(@record.original_url).to eq(existing_shorten_url.original_url)
        expect(@record.id).not_to eq(existing_shorten_url.id)
        expect(@record.alias).not_to eq(existing_shorten_url.alias)
      end
    end

    context 'when 1 user with 2 identical input URL' do
      let!(:existing_shorten_url) { ShortenUrl.create!(original_url:, user_id:) }

      it 'does not create the new alias URL' do
        expect { @record = service.call }.not_to change { ShortenUrl.count }

        expect(@record.id).to eq(existing_shorten_url.id)
      end

      it 'does not change the current alias' do
        expect { service.call }.not_to change { existing_shorten_url.alias }
      end
    end
  end
end
