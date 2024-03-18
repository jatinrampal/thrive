require 'json'
require_relative 'data_validation'
require_relative 'generate_output'
require_relative '../models/user'
require_relative '../models/company'

#Reading from file and parsing it as JSON data
def read_json(file)
  JSON.parse(File.read(file))
end

#Function to process user data, company data and generate email specific output
def process_emails(users_file, companies_file, output_file)
  #Reading from JSON files
  users_data = read_json(users_file)
  companies_data = read_json(companies_file)

  #Processing user data
  users = users_data.map do |user|
    #Checking if data is valid
    if validate_user(user)
      #Creating user upon successful validation
      User.new(user['id'], user['first_name'], user['last_name'], user['email'], user['company_id'], user['email_status'], user['active_status'], user['tokens'])
    else
      #Logging invalid data
      puts "Warning: Invalid user data: #{user}"
      nil
    end
  end.compact

  #Processing companies data
  companies = companies_data.map do |company|
    #Checking if data is valid
    if validate_company(company)
      #Creating company upon successful validation
      Company.new(company['id'], company['name'], company['top_up'], company['email_status'])
    else
      puts "Warning: Invalid company data: #{company}"
      nil
    end
  end.compact

  #Initializing variable for company data
  company_map = {}

  users.each do |user|
    #Checking if user is active
    next unless user.active_status

    #Checking if user's company id exists in the companies data
    company = companies.find { |c| c.id == user.company_id }
    next unless company

    #Creating company info block and adding to company map
    company_info = company_map[company.id] || { company: company, users_emailed: [], users_not_emailed: [], total_top_ups: 0 }
    company_map[company.id] = company_info

    #Calculations for top-ups
    previous_tokens = user.tokens
    user.tokens += company.top_up

    #Logic to check if user receives email or not
    if company.email_status && user.email_status
      company_info[:users_emailed] << { user: { **user.to_h, previous_tokens: previous_tokens } }
    else
      company_info[:users_not_emailed] << { user: { **user.to_h, previous_tokens: previous_tokens } }
    end

    company_info[:total_top_ups] += company.top_up
  end

  #Retrieving the result from the companies map while sorting by id
  companies_result = company_map.values.sort_by { |info| info[:company].id }

  #Writing the resulting data to the specified file
  File.open(output_file, 'w') do |stream|
    write_output(stream, companies_result)
  end
rescue StandardError => e
  puts "Error processing data: #{e.message}"
end
