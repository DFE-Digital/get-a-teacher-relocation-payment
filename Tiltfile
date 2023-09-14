# point Tilt at the existing docker-compose configuration.
docker_compose("./docker-compose.yml")

config.define_bool("local-app")

cfg = config.parse()

local_app = cfg.get("local-app", False)

resources = [
    "redis",
    "database",
    "app",
    "worker"
]


if local_app:
    resources.remove("app")
    resources.remove("worker")
    local_resource(
        "local_app",
        serve_cmd="./bin/app-startup.sh",
        serve_env={
         "RAILS_ENV": "development",
         "DATABASE_URL": "postgresql://gtrp:gtrp@localhost:5432/get_an_international_relocation_payment_development"
        },
        resource_deps=["database", "redis"],
        readiness_probe=probe(
            period_secs=15, http_get=http_get_action(port=3000, path="/healthcheck")
        ),
    )
    local_resource(
        "local_worker",
        serve_cmd="./bin/worker-startup.sh",
        resource_deps=["database", "redis"],
    )
    resources.append("local_app")
    resources.append("local_worker")


config.clear_enabled_resources()
config.set_enabled_resources(resources)
