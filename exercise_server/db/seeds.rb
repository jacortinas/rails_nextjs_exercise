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

frontend_url = ENV["FRONTEND_ROOT_URL"] || "http://localhost:3001"

Doorkeeper::Application.find_or_create_by!(
  name: "Exercise Frontend",
  redirect_uri: "#{frontend_url]}/api/auth/callback/exercise_server",
  uid: "fake_client_id",
  secret: "fake_client_secret",
  scopes: [:read, :write]
)

User.find_or_create_by!(email: "test@test.com") do |user|
  user.password = "password"
end