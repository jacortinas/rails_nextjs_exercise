# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.logger = Logger.new(STDOUT)

# This is how we're setting up an OAuth application for development purposes.
# The uid and secret here would normally be confidentially shared with the client applications
# that need to authenticate with the OAuth server. For the purposes of this exercise, they are just
# hardcoded.
Doorkeeper::Application.find_or_create_by!(
  name: "Exercise Frontend",
  redirect_uri: "http://localhost:3001/api/auth/callback/ledger_api",
  uid: "ledger-client-id",
  secret: "ledger-client-secret",
  scopes: [:read, :write]
)

User.find_or_create_by!(email: "test@test.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end