# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...



look at the seeds.rb and use that to save data to your db


-- Tables to use --


rails g model Asset pair base quote altbase name marketcap

rails g model Ask asset:references price volume timestamp
rails g model Bid asset:references price volume timestamp
rails g model Trade asset:references price volume time buysell marketlimit misc
rails g model Spread asset:references time bid ask


-- Undo/destroy models --
rails destroy model spreads 

rails c
ActiveRecord::Migration.drop_table('spreads')


-- look thru the db --
rails db
.tables
select * from assets

rails c
Asset.all
ActiveRecord::Base.connection.table_structure("asks")





