# Dartsass load-path
Rails.application.config.dartsass.build_options << " --load-path #{Rails.root.join('node_modules')} "

## Propshaft
Rails.application.config.assets.paths << Rails.root.join("vendor/assets")
Rails.application.config.assets.excluded_paths << Rails.root.join("app/assets/stylesheets")
