# frozen_string_literal: true

class ApplicationController < ActionController::API
  def current_user
    # do some thing to find user, if not found, use anonyous

    anonymous_user
  end

  def anonymous_user
    request.headers[:anonymous_id].presence || SecureRandom.uuid
  end
end
