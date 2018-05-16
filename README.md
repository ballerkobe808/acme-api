# README

This is a Ruby on Rails Cryptocurrency api that connects to three different cryptocurrency sources to serve to the ReactJs web client here: https://github.com/ballerkobe808/acme-trader-client

The bundled production build of the client comes bundled in the Public folder.
The three sources this api pull from are:
 https://www.kraken.com/help/api#public-market-data
 https://coinmarketcap.com/api
 https://www.isiterc20.com

This was built using:
Ruby 2.4.1 and Rails 5.2.0

Other libraries used are:
'nokogiri' (http://nokogiri.org/) for parsing the XML response
'active_model_serializers' (https://github.com/rails-api/active_model_serializers) for serving up data
'remote_syslog_logger' (https://github.com/papertrail/remote_syslog_logger) for sending logs to papertrail 

It is also using the default sqlite3 Database

To get the app up and running:

1. Clone the project from Github using:

  git clone https://github.com/ballerkobe808/acme-api.git

2. change to the cloned directory (default is acme-api)
 
  cd acme-api

3. Install the gemfiles using:

  bundle

4. Start the rails server using:

  rails s

5. In development mode, go to:

  localhost:3000 



Any feedback or questions feel free to email daniel.kong@gmail.com. Thanks for looking!







