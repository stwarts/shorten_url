# frozen_string_literal: true

class DecodesController < ApplicationController
  def create
    raise ActiveRecord::RecordNotFound if params[:url].blank?

    shorten_url = ShortenUrl.find_by!(alias: parse_alias_url, user_id: current_user)

    render json: { data: shorten_url }
  end

  private

  def parse_alias_url
    alias_url = params[:url].split(ShortenUrl::HOST)[-1]
    alias_url.delete_prefix('/')
  end
end
