# Exercise Server

This is a basic Rails app that is using:

- SQLite database
- SolidQueue gem
- Devise gem
- Doorkeeper gem
- Graphql-Ruby gem
- Sorbet gem
- Money gem

The importants parts are located in:

- `app/models/ledger.rb`
- `app/models/journal_entry.rb`
- `app/graphql/*`

Using Doorkeeper this Rails app serves as an OAuth2 provider for an app named "ledger_api".
This allows the frontend app to authenticate securely and retrieve an access token and refresh token
to make authenticated requests without the need to share cookies or the same domain.

The GraphQL API is simple with 2 main top-level fields. `Query.viewer` and `Query.ledger`.
The `Query.viewer` endpoint returns information about the initiator of the current GraphQL
request. The `Query.ledger` field contains the `years`, `year` and `entry` fields that allow
for further querying down the graph to retrieve journal entries for specific months.
