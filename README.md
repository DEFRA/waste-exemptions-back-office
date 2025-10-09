# Waste Exemptions Back Office

![Build Status](https://github.com/DEFRA/waste-exemptions-back-office/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-back-office&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-back-office)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-back-office&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-back-office)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

If your business produces waste or emissions that pollute you may require an environmental permit. However you may also be able to get an exemption if your business activities are considered to be easily controlled and only create low risks of pollution.

The waste exemptions service is used by organisations to apply for an exemption.

This service is currently beta public and has been developed in accordance with the [Digital by Default service standard](https://www.gov.uk/service-manual/digital-by-default), putting user needs first and delivered iteratively. 

This project is the back office application which internal staff use to register and manage exemptions via the assisted digital route. It uses the [waste-exemptions-engine](https://github.com/DEFRA/waste-exemptions-engine).

## Prequisites

You'll need [Ruby 3.4.6](https://www.ruby-lang.org/en/) installed plus the [Bundler](http://bundler.io/) gem.

## Installation

First clone the repository and then drop into your new local repo

```bash
git clone https://github.com/defra/waste-exemptions-back-office.git && cd waste-exemptions-back-office
```

Next download and install the dependencies

```bash
bundle install
```

## Running locally

A [Vagrant](https://www.vagrantup.com/) instance has been created allowing easy setup of the waste exemptions service. It includes installing all applications, databases and dependencies. This is located within GitLab (speak to the Ruby team).

Download the Vagrant project and create the VM using the instructions in its README.

However, if you intend to work with the app locally (as opposed to on the Vagrant instance) and just use the box for dependencies, you'll need to:

- Log in into the Vagrant instance
- Using `ps ax`, identify the pid of the running back office app
- Kill it using `kill [pid id]`
- Exit the vagrant instance

Once you've created a `.env` file (see below) you should be ready to work with and run the project locally.

## Configuration

Any configuration is expected to be driven by environment variables when the service is run in production as per [12 factor app](https://12factor.net/config).

However when running locally in development mode or in test it makes use of the [Dotenv](https://github.com/bkeepers/dotenv) gem. This is a shim that will load values stored in a `.env` file into the environment which the service will then pick up as though they were there all along.

Check out [.env.example](/.env.example) for details of what you need in your `.env` file, and what environment variables you'll need in production.

## Databases

If you are running the waste exemptions Vagrant VM, you have nothing to do! All databases are already created and the appropriate ports opened for access from the host to the VM.

If you intend to run it standalone, you'll need to have [PostgreSQL](https://www.postgresql.org/) installed and can then use `bundle exec rake db:create:all` to create the databases for the develop and test environments.

## Running the app

Simply start the app using `bundle exec rails s`. If you are in an environment with other Rails apps running you might find the default port of 3000 is in use and so get an error.

If that's the case use `bundle exec rails s -p 8000` swapping `8000` for whatever port you want to use.

## Govpay Mocks

The `defra_ruby_mocks` gem allows us to simulate the production GOV.UK Pay API, which behaves differently to the GOV.UK sandbox API. Refer to the mocks gem README for details.

In order to use the govpay mock you'll need to provide applicaton-specific configuration details:
- The root Govpay mock URLs for both front- and back-office. Both are required because the mocks for front-office point at back-office and vice-versa, and the mock gem needs to know both values for the two hosting applications.
- The external URL for both applications. These are required because the mock gem needs to map from internal-EC2 only URLs to externally accessible URLs.

For example, with the front-office and back-office mocks are mounted on `/fo/mocks` and `/bo/mocks` respectively:

```ruby
config/initializers/defra_ruby_mocks.rb
require "defra_ruby_mocks"

DefraRubyMocks.configure do |config|
  configuration.govpay_mocks_external_root_url = ENV.fetch("WEX_MOCK_BO_GOVPAY_URL", "http://localhost:3000/fo/mocks/govpay/v1")
  configuration.govpay_mocks_external_root_url_other = ENV.fetch("WEX_MOCK_FO_GOVPAY_URL", "http://localhost:8000/bo/mocks/govpay/v1")

  # On our hosted environments, the FO/BO mocks are accessible to each other via different URLs:
  configuration.govpay_mocks_internal_root_url = ENV.fetch("WEX_MOCK_BO_GOVPAY_URL_INTERNAL", "http://localhost:3000/fo/mocks/govpay/v1")
  configuration.govpay_mocks_internal_root_url_other = ENV.fetch("WEX_MOCK_FO_GOVPAY_URL_INTERNAL", "http://localhost:8000/bo/mocks/govpay/v1")
end
```

You'll also need to provide AWS configuration details for the mocks, for example:

```ruby
require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  govpay_mocks_bucket = {
    name: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_BUCKET"),
    region: ENV.fetch("AWS_REGION", "eu-west-1"),
    credentials: {
      access_key_id: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_SECRET_ACCESS_KEY")
    },
    encrypt_with_kms: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ENCRYPT_WITH_KMS", false)
  }

  c.buckets = [govpay_mocks_bucket]
end
```

## Testing the app

The test suite is written in RSpec.

To run all the tests, use `bundle exec rspec` or `bundle exec rake`.

## Debugging

Add breakpoints with `remote_byebug` and run `./bin/byebug` from *within your vagrant box* to start a session.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
