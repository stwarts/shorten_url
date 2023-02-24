# frozen_string_literal: true

class DecodesController < ApplicationController
  def create
    shorten_url = ShortenUrl::DecodeService.new(encoded_url: params[:url]).call

    render json: { data: shorten_url }
  end
end
