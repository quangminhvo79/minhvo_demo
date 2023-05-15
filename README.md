# YOUTUBE SHARING VIDEO

## Introduction
The application sharing Youtube video and realtime notification for new video shared

# Prerequisites

## Software require
- Ruby 3.1.2
- NodeJS 18.12.1
- Postgresql 13

## Stacks
- Rails7
- TailwindCSS
- Hotwired (Stimulus and Turbo)
- [View Component](https://github.com/mtcld/die-reguliere/blob/develop/app/components/readme.md)
- Rspec, Capybara for Unit test and Integration test
- Devise
- Rubocop

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
npm install
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

## Data seeding
You're should add the needed data into this file when implementing a new feature to make it run correct on local machine.

For first time or you want to reload demo data, just do:
```ruby
rails db:fixtures:load db:seed
```
Then you can access with 2 following credentials:

```ruby
admin@gmail.com / 123456
other@gmail.com / 123456
```

## Unit test and Integration test
I have setup Rspec to helps me definition for Unit test and Integration test (features folder)
to run test on your local machine, please use this:
```ruby
bundle exec rspec
```
or you can run test in particular file:
```ruby
bundle exec rspec <file-path>
```

## Rubocop
Use Rubocop to helps automatically checks our code for common style violations and provides helpful suggestions for improving our code quality. To run rubocop on your local machine, please use this:
```ruby
bundle exec rubocop -a
```

## Usage

This application was built to help users share interesting videos from YouTube. To share a video, you need to log in first. Once logged in, you will see a 'Share Video' button in the top-right corner of the screen. Clicking this button will open a modal where you can input the YouTube URL and submit it. The shared video will then be available for others to view."

If you are logged in, you will receive notifications when a new video is shared, as well as when other users react to your videos.

The notification will show up in bottom-right corner of the screen

## Troubleshooting

If you are running this application on your local machine, please remember to set the YOUTUBE_API_KEY in the .env file. If this is not done, the service that retrieves video snippets will not work and you will not be able to share videos.

If the YouTube video link is incorrect or the video does not exist, you will also not be able to share videos.

In error case, i was show a notification in bottom-right corner to let you identify which is issues.
