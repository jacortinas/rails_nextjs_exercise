# Rails + Relay Exercise

This is a repository for a demo app containing:

- A Rails app acting as OAuth2 provider and GraphQL API.
- A next.js app acting as a server rendered React frontend.

The purpose of the app is to load a CSV of data into the Rails app's database, aggregate the data by month
and allow that data to be accessed via GraphQL API. Authentication was an extra feature but demonstrates how to use Next.js and Auth.js with Rails, Devise, and Doorkeeper.

In order to run the app, you must have a recent version of node installed and Ruby 3.4.2. If you want to use another Ruby version you can, this is just the version I used when building the demo.

I don't recommend running the following commands unless you know that you want to install these tools. This is just what have used to get the correct tools installed.
```
$ brew install nvm chruby ruby-install overmind
$ nvm install node
$ ruby-install install ruby
```


Once Ruby and Node are correctly configured run:

```
$ script/setup
```

To install the dependencies for both apps and to prepare the database. Then run:

```
$ script/dev
```

To run the apps. Navigate to `http://localhost:3001` to view the homepage.

