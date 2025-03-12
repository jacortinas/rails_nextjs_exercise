# Rails + GraphQL + Next.js Exercise

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

The apps looks like:

![Ledger Root Page](https://github.com/user-attachments/assets/590417b9-3e3f-4f94-845b-111bb62a2150)
![Sign In Page](https://github.com/user-attachments/assets/d5ef1fba-de94-4623-888f-51404a147a33)
![Signed In Homepage](https://github.com/user-attachments/assets/518db544-14f3-4ad1-8803-e619f5c566b6)
![Ledger Page](https://github.com/user-attachments/assets/54029329-c217-4178-93a6-a203c3bbf963)
![Dropdown Open](https://github.com/user-attachments/assets/9ad765b9-89b9-4938-86c8-fe475a21902b)
