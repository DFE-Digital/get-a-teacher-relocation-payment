# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :check_service_open!, except: %i[closed]
  def start; end
  def closed; end
end
