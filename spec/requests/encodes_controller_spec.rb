# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EncodesController, type: :request do
  describe 'POST /encode' do
    context 'when failed' do
      let(:encode_params) { {} }

      it 'returns error' do
        post '/encode', params: encode_params, headers: { 'Anonymous-Id' => 'id' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end

    context 'when no user' do
      let(:encode_params) { { url: 'https://example.com' } }

      it 'returns error' do
        post '/encode', params: encode_params, headers: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end

    context 'when successful' do
      let(:encode_params) { { url: 'https://example.com' } }

      it 'creates a shorten version for the input URL' do
        post '/encode', params: encode_params, headers: { 'Anonymous-Id' => 'id' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data'].fetch('alias')).not_to be_empty
      end
    end
  end
end
