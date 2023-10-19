namespace :assets do
  desc "Copy govuk-frontend assets to vendor assets folder"
  task vendor: :environment do
    node_govuk_assets_path = Rails.root.join("node_modules/govuk-frontend/govuk/assets")
    govuk_assets_path = Rails.root.join("vendor/assets")

    system("yarn --frozen-lockfile")
    system("yarn cache clean")
    system("mkdir -p #{govuk_assets_path}/assets")
    system("cp -r #{node_govuk_assets_path} #{govuk_assets_path}")
  end
end

Rake::Task["dartsass:build"].enhance(["assets:vendor"])
