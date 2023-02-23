# frozen_string_literal: true

class DecodesController < ApplicationController
  def create
    raise ActiveRecord::RecordNotFound if params[:url].blank?

    shorten_url = ShortenUrl.find_by!(alias: params[:url], user_id: current_user)

    render json: { data: shorten_url }
  end
end
