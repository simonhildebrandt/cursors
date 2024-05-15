# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Book.destroy_all

IO.readlines('./books.txt').each.with_index do |line, index|
  line.match(/(.+) \((\d{4})\)/) do |match|
    Book.create!(
      title: match[1],
      published_year: match[2],
      # created_at: Time.now + (index * 10).minutes
    )
    sleep 0.1
  end
end
