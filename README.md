# plangrade API Gem
[![Gem Version](https://badge.fury.io/rb/plangrade-ruby.svg)](http://badge.fury.io/rb/plangrade-ruby)
[![Code Climate](https://codeclimate.com/github/topherreynoso/plangrade-ruby/badges/gpa.svg)](https://codeclimate.com/github/topherreynoso/plangrade-ruby)
[![Coverage Status](https://coveralls.io/repos/topherreynoso/plangrade-ruby/badge.png?branch=master)](https://coveralls.io/r/topherreynoso/plangrade-ruby?branch=master)
[![Build Status](https://travis-ci.org/topherreynoso/plangrade-ruby.svg?branch=master)](https://travis-ci.org/topherreynoso/plangrade-ruby)

Ruby wrapper for the plangrade API.

Supports OAuth 2.0 authentication, including `refresh_token`. Read the [plangrade docs](https://docs.plangrade.com/#authentication) for more details. 

Additionally, this may be used in conjunction with [omniauth-plangrade](https://github.com/topherreynoso/omniauth-plangrade) in order to facilitate authentication and obtaining a valid `access_token` and `refresh_token` pair for use with this gem to access plangrade API endpoints.

See the [plangrade-ruby-client](https://github.com/topherreynoso/plangrade-ruby-client) example for implementation of both omniauth-plangrade and plangrade-ruby.

This README provides only a basic overview of how to use this gem. For more information about the API endpoints, look at the [plangrade docs](https://docs.plangrade.com/#authentication).

## Installing

Add this line to your application's Gemfile:

    gem 'plangrade-ruby'

And then execute:

    $ bundle install

## Configuration

The plangrade API requires authentication for access to certain endpoints. Below are the basic steps to get this done.

### Register your application

Setup a plangrade client application at the [plangrade developer site](https://plangrade.com/oauth/applications).

### Using omniauth-plangrade to obtain an access token

You can use [omniauth-plangrade](https://github.com/topherreynoso/omniauth-plangrade) to obtain a valid access token, as demonstrated below.

```ruby
# In your redirect_uri after the user authorized access, just parse the omniauth response
auth = request.env["omniauth.auth"]
access_token = auth["credentials"]["token"]
refresh_token = auth["credentials"]["refresh_token"]
```

### Using plangrade-ruby OAuth2 Client to obtain an access token

This gem comes bundled with an OAuth2 wrapper that provides convenience methods for getting through the OAuth2 flow.

```ruby
# Be sure to require plangrade in any controller where you utilize plangrade-ruby
require 'plangrade'

# Begin by getting the authorization url
plangrade_client = Plangrade::OAuth2Client.new(ENV['PLANGRADE_CLIENT_ID'], ENV['PLANGRADE_CLIENT_SECRET'])
auth_url = plangrade_client.webserver_authorization_url(:redirect_uri => 'your_redirect_uri')
```

After the user follows the link created above and authorizes your app, they will be redirected to your `redirect_uri`, with a code in the params that you can use to obtain an access token.

```ruby
plangrade_client = Plangrade::OAuth2Client.new(ENV['PLANGRADE_CLIENT_ID'], ENV['PLANGRADE_CLIENT_SECRET'])
response = plangrade_client.exchange_auth_code_for_token({:params => {:code => params[:code], :redirect_uri => 'your_redirect_uri'}})
token = JSON.parse response.body
access_token = token["access_token"]
refresh_token = token["refresh_token"]
```

You may want to store the `access_token` since it is good for two hours. You may also want to store the `refresh_token` since it can be used to get a new `access_token` at any time, so long as the user does not revoke your app's authorization.

### Using a stored `refresh_token` to obtain an access token

This gem also allows you to use a `refresh_token` to obtain a new `access_token`.

```ruby
# Set up a plangrade OAuth2 client and retrieve your refresh_token
plangrade_client = Plangrade::OAuth2Client.new(ENV['PLANGRADE_CLIENT_ID'], ENV['PLANGRADE_CLIENT_SECRET'])
response = plangrade_client.refresh_access_token({:params => {:refresh_token => 'your_refresh_token'}})
token = JSON.parse response.body
access_token = token["access_token"]
refresh_token = token["refresh_token"]
```

### Using plangrade API client to access REST endpoints

You can view the current state of the client using the `Plangrade#options` method.

```ruby
require 'plangrade'

Plangrade.options
#> {:site_url=>"https://plangrade.com", :client_id=>your_client_id, :client_secret=>your_client_secret, :access_token=>current_access_token, :http_adapter=>Plangrade::Connection, :connection_options=>{:max_redirect=>5, :use_ssl=>true}}
```

To change the configuration parameters use the `configure` method. If you set your client_id and client_secret as `ENV['PLANGRADE_CLIENT_ID']` and `ENV['PLANGRADE_CLIENT_SECRET']` then this will automatically be set for you.

```ruby
Plangrade.configure do |p|
  p.client_id = your_client_id
  p.client_secret = your_client_secret
end
```

At this point the `access_token` is nil. This will need to be set and, in the next section, we will see how to do this.

## Usage

This gem offers three ways to interact with plangrade's API:

1. Calling methods on `Plangrade` module. (Returns an API response)
2. Calling methods on an instance of `Plangrade::Client`. (Returns an API response)
3. Calling methods on the custom object models. (Returns identity mapped objects)

### Calling methods on the plangrade module

In order for this to work, you will need to set up your `access_token`. This assumes that you already configured the client with your default options as was described above.

```ruby
# Set up your access_token
Plangrade.configure do |p|
  p.access_token = your_access_token
end

# Get the current user
Plangrade.current_user
```

### Calling methods on an instance of Plangrade::Client

**Note:** Use this if you wish to create multiple client instances with different `client_id`, `client_secret`, and/or `access_token`. If your application uses a single pair of `client_id` and `client_secret` credentials, you ONLY need to specify the `access_token`.

```ruby
# Create a client instance using the access_token
plangrade = Plangrade::Client.new(:access_token => your_access_token)
```

Call methods on the instance.

**User**

Current user info

```ruby
user = plangrade.current_user
user_name = user[:name]
```

Create new user

```ruby
new_user_id = plangrade.create_user(params)
```

Update user

```ruby
updated_user = plangrade.update_user(id, params)
```

Delete user

```ruby
plangrade.delete_user(id)
```

**Companies**

Create new company

```ruby
new_company_id = plangrade.create_company(params)
```

Get company info

```ruby
company = plangrade.get_company(id)
```

Get all of a user's companies

```ruby
companies = plangrade.all_companies
```

Update company

```ruby
updated_company = plangrade.update_company(id, params)
```

Delete company

```ruby
plangrade.delete_company(id)
```

**Participants**

Create new participant

```ruby
new_participant_id = plangrade.create_participant(params)
```

Get participant info

```ruby
participant = plangrade.get_participant(id)
```

Get all of a company's participants

```ruby
participants = plangrade.all_participants(:company_id => id, params)
```

Update participant info

```ruby
updated_participant = plangrade.update_participant(id, params)
```

Archive participant

```ruby
archived_participant_id = plangrade.archive_participant(id)
```

Delete participant

```ruby
plangrade.delete_participant(id)
```

### Using the object models

The object model is an abstraction that makes it easy to manipulate the JSON data return when accessing plangrade's API. Each model has accessor methods for all keys contained in the JSON response for a given model type.

**Users**

```ruby
user_id = Plangrade::Resources::User.create(user_email_here, user_name_here)
user = Plangrade::Resouces::User.current_user
user.name
user.email
user.update!(:email => "compliance@plangrade.com")
user.delete!
```

**Companies**

```ruby
company1 = Plangrade::Resources::Company.create(company_ein_here, company_name_here)
company2 = Plangrade::Resources::Company.get(id)
companies = Plangrade::Resources::Company.all
company2.name
company2.ein
company2.grade
company2.update!(:name => "plangrade, llc")
company2.delete!
```

**Patricipants**
```ruby
participant1 = Plangrade::Resources::Participant.create(company_id, first_name, last_name, 
														street1, street2, city, state, zip, 
														dob, ssn, email, phone, employee_id)
participant2 = Plangrade::Resources::Participant.get(id)
participants = Plangrade::Resources::Participant.all
participant2.first_name
participant2.last_name
participant2.company_id
...
participant2.update!(:first_name => "Johnny")
participant2.archive!
participant2.delete!
```

## Supported Ruby Versions

This library aims to support and is [tested against](https://travis-ci.org/topherreynoso/plangrade-ruby) the following Ruby versions:

1. Ruby 1.9.3
2. Ruby 2.0.0
3. Ruby 2.1.0

This library may inadvertently work (or seem to work) on other Ruby implementations, however, support will only be provided for the versions listed above.

## License

Copyright (c) 2014 Christopher Reynoso

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
