Aspire Reader Tool
=========

Objective and Context
----
http://aspirereader.herokuapp.com

  - Allow Aspire Readers to easily grade observations
  - Records indicator scores and allows for comments on the indicator scores
  - Enables reader 2 to have a copy of reader 1a and 1b scores to verify.
  - One-page app using AJAX callbacks in rails.

Key Terms
----
* Domains
* Indicators
* Evidence Scores
* Observation Reads
* reader1a - reader gets only partial reads
* reader1b - reader gets the other half of the reads
* reader2 - reader 2 gets all of 1a and 1b reads copied in the database

Version
----
1.0  (March 28, 20140)

Rails 3.2 (upgrade to rails 4.1 soon)

Ruby 1.9.3

Technical Overview
-----------------
This tool exhibits certain technologies
* AJAX for to make it one-page

Readers1a and 1b's scores get copied into the reader2 so that the Reader 2 can recieve all the scores and simply update changes if necessary.  Look into the Observation Reads models to see these changes.

Testing
-------

Tests are pending.  Push for tests.  Although tests are slow at the beginning regardless how big and small the app is, testing should always be done.  This relieves anyone from technical debt down the road.  It's slow at the begining but sometimes the best apps the most well-tested apps  Please test!

* models are tested
* controllers tests [pending]
* feature tests [pending]
* javascript tests [pending]


```sh
rspec spec
```

External Dependencies
-----------
* [Twitter Bootstrap] - great UI boilerplate for modern web apps
* [jQuery] - of course
* Rpec - Rails testing suite
* Capybara - testing feature testing
* Shoulda-Matchers - testing models
* Jasmine - JavaScript Testing
* Heroku - for Database
* Factory-girl - to create factories for testing.

Installation
--------------

```sh
git clone https://github.com/aspire-public-schools/reader-tool.git
...
bundle install
...
Heroku pg:pull DATABASE_URL reader_tool_development –app aspirereader
```
You will need permission to a heroku account to pull down anything external that gets pushed up internally.  All migrations are set-up externally from the app.

Schema is key to understanding this.  Look up the XML pasted in the `db` folder and load it into this site for a clear picture of the database

http://ondras.zarovi.cz/sql/demo/

Support Concerns
-----
Currently the app is not fully tested with Rspec.  Be careful of any changes without any written tests.

Support issues
-----
Any other support concerns contact the Director of Technology at Aspire or the creator of the app gary.m.tsai@gmail.com.  His github is gary1410

