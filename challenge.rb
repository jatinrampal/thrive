require_relative 'helper/data_processing'

users_file = 'challenge-docs/users.json'
companies_file = 'challenge-docs/companies.json'
output_file = 'output.txt'

begin
  process_emails(users_file, companies_file, output_file)
rescue StandardError => e
  puts "Error processing data: #{e.message}"
end
