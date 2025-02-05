# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :check_service_open!, except: %i[closed sitemap]

  def index; end
  def closed; end
  def sitemap; end

  def ineligible
    session.delete("form_id")
  end

  def ineligible_salaried_course
    session.delete("form_id")
  end
end
