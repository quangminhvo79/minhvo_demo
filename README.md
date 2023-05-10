# YOUTUBE SHARING VIDEO

## Introduction
The application sharing Youtube video.

# Prerequisites

## Software require
- Ruby 3.1.2
- NodeJS 18.12.1
- Postgresql 13

## Stacks
- Rails7
- TailwindCSS
- Hotwired (Stimulus and Turbo)

## Getting started

This application is built using the *Ruby* version 3.1.2 and *Rails* 7.0.4.3.
A step by step series of how to get the development evn running.

1. Clone the project to your local machine

```
git clone git@github.com:quangminhvo79/minhvo_demo.git
```

2. install all dependencies:

```
cd minhvo_demo
bundle install
```

3. create development and testing env database:

```
rails db:create
rails db:schema:load
```

4. Start the server

```
bin/dev
```

### Data seeding
You're should add the needed data into this file when implementing a new feature to make it run correct on local machine.

For first time or you want to reload demo data, just do:
```ruby
rake db:truncate_all db:fixtures:load db:seed
```
