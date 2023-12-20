# Get an International Relocation Payment

A service to collect details from teachers and trainees applying for the
International Relocation Payment.

## Robots.txt

A robots.txt file is located at `public/robots.txt` and prevents all robots from
crawling the site. This is to prevent the site from being indexed by search engines
while we are doing pen-testing in production for 2 days.

We should remove the lines below before moving to production.

```txt
User-agent: *
Disallow: /
```

## Development

### Install build dependencies

The required versions of build tools is defined in
[.tool-versions](.tool-versions). These can be automatically installed with
[asdf-vm](https://asdf-vm.com/), see their [installation
instructions](https://asdf-vm.com/#/core-manage-asdf).

Once installed, run:

```bash
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add bundler
asdf plugin add tilt
asdf install
```

When the versions are updated on the `main` branch run `asdf install` again to update your
installation. Use `asdf plugin update --all` to update plugins and get access to
newer versions of tools.

Create your `.env` from the `.env.example` template

- GOVUK_NOTIFY_API_KEY, using the citest api key
- GOVUK_NOTIFY_GENERIC_EMAIL_TEMPLATE_ID, template id used by mail-notify
- AZURE_CLIENT_ID, to access application platform
- AZURE_CLIENT_SECRET
- AZURE_TENANT_ID
- REDIS_URL, redis url for sidekiq
- LOCAL_USER_EMAIL, your education.gov.uk email address to access the system_admin section

### Manual development setup

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas
4. Run `bundle exec foreman start -f Procfile.dev` to launch the app on <http://localhost:3000>

### Docker based development setup

There are two ways to use this approach:

1. Run `tilt up -- --local-app` to launch the app on <http://localhost:3000>
   This will setup all the dependencies for you and run the server locally ie not in a docker image
   It is convienient when developing because you do not have to constantly rebuilt the docker image.

2. Run `tilt up` that way you will be building the image defined by the Dockerfile
   This approach is more closely aligned with a production environment.
   You will need to create you own certificates in the nginx folder.

   Using the [mkcert tool](https://github.com/FiloSottile/mkcert) you can acheive this with the following command
   `$ cd nginx && mkcert -key-file key.pem -cert-file cert.pem itrp.local *.itrp.local`
   and update your `/etc/hosts` file with `127.0.0.1       itrp.local`


This option will start the application and run the `db/seed.rb` file.

## Running specs

Run the full test suite with:

```bash
bundle exec rake
```

## Platform

You need to request `digitalauth.education.gov.uk` account before being able to access a deployed
instance.
Once your account active you need to request your temporary access token at
[portal.azure.com](https://portal.azure.com/#view/Microsoft_Azure_PIMCommon/ActivationMenuBlade/~/azurerbac)

The following environment are available on the platform:

- qa
- review, deployed on demand by adding the `deploy` label on a PR
- staging
- production

### Environment variables

When adding / removing or editing along side the code changes you will need to update the all the
available environments.
Run the following command `make <environment> edit-app-secrets`

#### Contract Start Date
The environment variable `CONTRACT_START_MONTHS_LIMIT` can be set to `5` to override 
the default of six months prior to the current service start date.
`AppSettings.current.service_start_date`.
This can be set to either `5` or `6` anything else will default to `6`.

### SSH access

Access a deploy with the command `make <environment> ssh`.

## Architectural Decision Record

See the [docs/adr](docs/adr) directory for a list of the Architectural Decision
Record (ADR). We use [adr-tools](https://github.com/npryce/adr-tools) to manage
our ADRs, see the link for how to install (hint: `brew install adr-tools` or use
ASDF).

To create a new ADR, run:

```bash
adr new "Title of ADR"
```

### Contingency

This service does not offer any out of hours SLAs and there will be not on call shift.

Any incidents observed should follow [the incident reporting guidance](https://tech-docs.teacherservices.cloud/operating-a-service/incident-playbook.html)

## Azure Login

See [docs/azure-login.md](docs/azure-login.md) for details on how to log in functionality works.
