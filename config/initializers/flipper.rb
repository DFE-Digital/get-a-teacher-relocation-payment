class CanAccessFlipperUI
  def self.matches?(request)
    current_user = request.env["warden"].user
    current_user.present?
  end
end

Flipper::UI.configure do |config|
  config.banner_text = "#{Rails.env.capitalize} Environment"
  config.banner_class = Rails.env.production? ? "danger" : "warning"
  config.cloud_recommendation = false
  config.fun = false
end
