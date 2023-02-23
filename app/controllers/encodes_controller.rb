# frozen_string_literal: true

class EncodesController < ApplicationController
  def create
    shorten_url = ShortenUrl::EncodeService.new(original_url: encode_params[:url], user_id: current_user).call

    if shorten_url.errors.empty?
      render json: { data: shorten_url }
    else
      render json: { errors: shorten_url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def encode_params
    params.permit(:url)
  end
end
