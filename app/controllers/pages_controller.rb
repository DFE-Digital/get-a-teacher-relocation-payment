# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :check_service_open!, except: %i[closed sitemap sentry]
  def index; end
  def closed; end
  def sitemap; end

  def sentry
    raise(StandardError, "This a test for sentry")
  end
end
