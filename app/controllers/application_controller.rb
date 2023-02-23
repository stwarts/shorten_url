# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  # do some thing to find user, if not found, use anonymous_id
  def current_user
    anonymous_user
  end

  def anonymous_user
    request.headers[:anonymous_id].presence
  end
end
