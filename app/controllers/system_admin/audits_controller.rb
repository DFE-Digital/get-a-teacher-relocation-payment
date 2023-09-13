module SystemAdmin
  class AuditsController < AdminController
    include Pagy::Backend
    def index
      @pagy, @audits = pagy(Audited::Audit.all.where.not(user_id: nil).order(created_at: :desc), items: 10)
    end
  end
end
