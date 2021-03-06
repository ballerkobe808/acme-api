
# ACME API (Bundled with the Acme Trader Client)

This is a Ruby on Rails Cryptocurrency api built using Ruby on Rails 5 that connects to three different cryptocurrency sources to serve an api used by the ReactJs web client here: 

- https://github.com/ballerkobe808/acme-trader-client

The bundled production build of the acme trader client is located in the Public folder.
The three sources this api pulls from are:

 - https://www.kraken.com/help/api#public-market-data (coin list and graphical data)
 - https://coinmarketcap.com/api (coin name and market cap)
 - https://www.isiterc20.com (ERC20 flag)




## Demo

For a demo of the working version of the app visit: https://acme-trader-client.herokuapp.com

---

## Requirements

For development, it is recommended to use Ruby 2.4.1 and Rails 5.2.0



## Install the App

    $ git clone https://github.com/ballerkobe808/acme-api.git
    $ cd acme-api
    $ bundle

## Build the Database
The current version of this app uses Postgres. For simple instructions to install Postgres locally to your system you can visit: https://devcenter.heroku.com/articles/heroku-postgresql#local-setup

After Postgres is installed and running you need to create and migrate the database defined in the config/database.yml file.

    $ rake db:create
    $ rake db:migrate

## Start the App

    $ rails s
    Point your browser to: http://localhost:3000

---

## Languages & tools

### Ruby 

- [Ruby](https://www.ruby-lang.org/en/) is used to build the api

### Rails

- [Rails](https://rubyonrails.org/) is used bundled with ruby to serve the api and the static files needed for the app

### Nokogiri

- [Nokogiri](http://nokogiri.org) is used for parsing the HTML page with the ERC20 check

### Active Model Serializers

- [Active Model Serializers](https://github.com/rails-api/active_model_serializers) is used to help with creating and serving a RESTful api

### Remote Sys Logger

- [Remote Sys Logger](https://github.com/papertrail/remote_syslog_logger) is used for sending logs to papertrail 



Any feedback or questions feel free to email daniel.kong@gmail.com. Thanks for looking!







rake db:create
rake db:migrate



