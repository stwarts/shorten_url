# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecodesController, type: :request do
  describe 'POST /decode' do
    let(:decode_params) { { url: to_be_decoded_url } }
    let!(:shorten_url) { ShortenUrl.create!(original_url: 'https://example.com', user_id: current_user, alias: 'QWERTY') }
    let(:current_user) { SecureRandom.uuid }
    let(:headers) do
      { 'Anonymous-Id' => current_user }
    end

    let(:parsed_data) { JSON.parse(response.body)['data'] }

    context 'when alias URL exists' do
      let(:to_be_decoded_url) { shorten_url.alias_with_host }

      context 'when user does not own the shorten URL' do
        let(:other_user) { SecureRandom.uuid }

        it 'returns not_found error' do
          post '/decode', params: decode_params, headers: { 'Anonymous-Id' => other_user }

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user owns the shorten URL' do
        it 'returns success' do
          post('/decode', params: decode_params, headers:)

          expect(response).to have_http_status(:ok)
          expect(parsed_data.fetch('original_url')).to eq('https://example.com')
        end
      end
    end

    context 'when alias URL does not exist' do
      let(:to_be_decoded_url) { 'not found' }

      it 'returns not_found error' do
        post('/decode', params: decode_params, headers:)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_empty
      end

      context 'when alias URL is null' do
        let(:shorten_url) { nil }
        let(:to_be_decoded_url) { nil }

        it 'returns not_found error' do
          post('/decode', params: decode_params, headers:)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to be_empty
        end
      end
    end
  end
end
