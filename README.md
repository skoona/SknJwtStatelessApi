# SknJwtStateless
An exploration into STATELESS API Ruby development using [JWT's](https://github.com/jwt/ruby-jwt), custom [Rack](https://github.com/rack/rack) filter, and [Roda](https://github.com/jeremyevans/roda) application tooling.

In concept, I plan to create a `runtime` which will provide a login URI which will validate a user's basic-auth credentials and issue a JWT.  Once, issued
the client will insert the JWT in a `Authorization:Bearer <token>` header which is included in every api request. 

A Rack Filter will validate the JWT and set the current user into the environment for the API application.  The current user
object carries [JWT Scopes and Claims](https://auth0.com/docs/scopes/current/sample-use-cases#authenticate-a-user-and-request-standard-claims) which are used to authorize access to certain API methods. 

While minimal; this app is operational and contains a rack filter component, and two roda-based rack 
applications.  One which produces JWT's, and the other providing Money operations like view, 
add, and remove money from a [PStore](https://ruby-doc.org/stdlib-2.2.1/libdoc/yaml/rdoc/YAML/Store.html) account by user.

            *Implementation example of a Stateless and JWT Secured API, Ruby programming.*

#### Existing Credentials
    username: `emuser`           username: `emkeeper`               username: `emowner`          
    password: `emuser pwd`       password: `emkeeper pwd`           password: `emowner pwd`
    scopes: `view_money`     scopes: `view_money, add_money`    scopes: `view_money, add_money, remove_money`


#### Runtime Model
```text
WebServer
├── Rack
    ├─────[/...]──[Authenticator App]:public
    └─────[/api/v1/...]──[JWT Validator/Filter]──[Money Demo App]:secured
 
```

#### Paths
    Public                                       ANY <host:port>/status           Application Runtime Metrics

    Authorization:Basic <B64(username:password)> ANY <host:port>/authenticate     Validate and return JWT Token
    Authorization:Basic <B64(username:password)> ANY <host:port>/register         Enroll a new user with password

    Authorization:Bearer <token> GET    <host:port>/api/v1/money                  View Balance
    Authorization:Bearer <token> POST   <host:port>/api/v1/money?amount=50        Add amount to Balance
    Authorization:Bearer <token> DELETE <host:port>/api/v1/money?amount=50        Remove amount from Balance

### Potential UseCases
#### Existing User
1. POST <host>/authenticate   -- to receive a JWT Token using new creds     
2. GET  <host>/api/v1/money   -- to view initial money balance
3. POST <host>/api/v1/money?amount=100   -- to ADD money
4. GET  <host>/api/v1/money              -- to VIEW money 
5. DELETE <host>/api/v1/money?amount=10  -- to REMOVE money
6. GET  <host>/api/v1/money              -- to VIEW money ~~ 100
7. `Stateless` does not require a logoff

#### New User
1. POST <host>/register       with BasicAuth a new username and password
2. POST <host>/authenticate   to receive a JWT Token using new creds     
3. GET  <host>/api/v1/money   to view initial money balance
4. POST <host>/api/v1/money?amount=100   -- to ADD money
5. GET  <host>/api/v1/money              -- to VIEW money 
6. DELETE <host>/api/v1/money?amount=10  -- to REMOVE money: Not Authorized for New Users
7. GET  <host>/api/v1/money              -- to VIEW money ~~ 100
8. `Stateless` does not require a logoff

## Installation
Benefits from two environment variables as overrides to the /config/settings.yml application settings; use your own values.  
```ruby
ENV['JWT_ISSUER'] = 'skoona.net'
ENV['JWT_SECRET'] = 'sknSuperSecrets'
```

<dl>
    <dt>Install Gems:</dt>
        <dd><code>$ bundle install</code></dd>
    <dt>Start Server with Puma, Port 8080:</dt>
        <dd><code>$ bundle exec puma -C ./config/puma.rb</code></dd>
    <dt>Start Console with Pry:</dt>
        <dd><code>$ bin/console</code></dd>
    <dt>Start Console with RackSh:</dt>
        <dd><code>$ bundle exec racksh</code></dd>
</dl>

### Core Technology
* Ruby 2.6+
* [Rack](https://github.com/rack/rack)
    * Web Server Interface and Runner
* [Roda](https://github.com/jeremyevans/roda)
    * Rack-based Web Framework (Best Available!)
* [SknUtils](https://github.com/skoona/skn_utils) 
    * Common utilities, dependencyInjection, Configuration, Application Supports
* [JWT](https://github.com/jwt/ruby-jwt)
    * Jason Web Token, security token influenced by [JWT Scopes and Claims](https://auth0.com/docs/scopes/current/sample-use-cases#authenticate-a-user-and-request-standard-claims)
* [PStore](https://ruby-doc.org/stdlib-2.2.1/libdoc/yaml/rdoc/YAML/Store.html)
    * Yaml file database for local user/account persistence

## File Tree
```text
❯ tree
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── Gemfile.lock
├── LICENSE
├── README.md
├── Rakefile
├── bin
│   └── console
├── config
│   ├── boot.rb
│   ├── datasources
│   │   ├── accounts_store.yml
│   │   └── credentials_store.yml
│   ├── environment.rb
│   ├── initializers
│   │   ├── 00-init_skn_configuraiton.rb
│   │   ├── 01-init_skn_configurable.rb
│   │   └── 02-init_logging.rb
│   ├── puma.rb
│   ├── settings
│   │   ├── development.local.yml
│   │   ├── development.yml
│   │   ├── production.yml
│   │   └── test.yml
│   ├── settings.yml
│   └── version.rb
├── config.ru
├── coverage
│   └── rspec_results.html
├── log
│   └── test-console.log
├── mains
│   ├── jwt_auth_filter.rb
│   ├── jwt_authenticator.rb
│   ├── jwt_stateless_api.rb
│   ├── mains.rb
│   ├── user.rb
│   └── user_datasource.rb
├── spec
│   ├── factories
│   │   ├── test_accounts_store.yml
│   │   └── test_credentials_store.yml
│   ├── mains
│   │   ├── basic_uri_spec.rb
│   │   └── user_datasource_spec.rb
│   └── spec_helper.rb
└── tmp
    ├── pids
    ├── puma.log
    └── puma.state
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
