module SystemAdmin
  class AuditsController < AdminController
    include Pagy::Backend
    def index
      @pagy, @audits = pagy(Audited::Audit.all.order(created_at: :desc), items: 10)
    end
  end
end
