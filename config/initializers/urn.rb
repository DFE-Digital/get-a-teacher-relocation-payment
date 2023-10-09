require Rails.root.join("app/models/urn")

Urn.configure do |c|
  c.prefix = "IRP"
  c.max_suffix = 99_999
  c.urns = ->(route) { Application.where(application_route: route).pluck(:urn) }
end
