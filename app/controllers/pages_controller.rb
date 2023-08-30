# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :check_service_open!, except: %i[closed sitemap]
  def index; end
  def closed; end
  def sitemap; end
end
