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

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas
4. Run `bundle exec rails server` to launch the app on <http://localhost:3000>
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets


## Setup using Tilt
To have a development environment setup quickly with all the dependencies you can use [Tilt](https://tilt.dev/).
1. Create your local `.env` file from `.env.example`
2. Update your local `.env` with relevant information
3. Add your education.gov.uk email address to `LOCAL_USER_EMAIL` in `.env`
4. Run `tilt up` to start the server

For development convenience you should use `tilt up -- --local-app`

## Running specs

Run the full test suite with:

```bash
bundle exec rake
```

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

### Hosting

TODO
