# Helper function to add tab indentations
def write_indented(stream, line, level = 0)
  stream.write("\t" * level + line + "\n")
end

#Helper function to write users
def write_users(stream, users, level)
  users
    #Sorting based on last name
    .sort_by { |data| data[:user][:last_name] }
    .each do |data|
    #Retrieving user data from hash
    user = data[:user]
    #Adding user details with appropriate indentation
    write_indented(stream, "#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}", level)
    write_indented(stream, "  Previous Token Balance: #{user[:previous_tokens]}", level)
    write_indented(stream, "  New Token Balance: #{user[:tokens]}", level)
  end
end


def write_output(stream, companies)
  companies.each do |company_info|
    #Retrieving company data from hash
    company = company_info[:company]
    users_emailed = company_info[:users_emailed]
    users_not_emailed = company_info[:users_not_emailed]
    total_top_ups = company_info[:total_top_ups]

    #Adding company details with appropriate indentation
    write_indented(stream, "Company Id: #{company.id}", 1)
    write_indented(stream, "Company Name: #{company.name}", 1)
    write_indented(stream, 'Users Emailed:', 1)
    write_users(stream, users_emailed, 2)
    write_indented(stream, 'Users Not Emailed:', 1)
    write_users(stream, users_not_emailed, 2)
    write_indented(stream, "Total amount of top-ups for #{company.name}: #{total_top_ups}\n", 2)
  end
  stream.close
end
