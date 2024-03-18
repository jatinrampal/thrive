require 'dry-validation'

#Schema for validating user data with Dry Schema Params
UserSchema = Dry::Schema.Params do
  required(:id).filled(:int?)
  required(:first_name).filled(:str?)
  required(:last_name).filled(:str?)
  required(:email).filled(:str?, format?: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  required(:company_id).filled(:int?)
  required(:email_status).filled(:bool?)
  required(:active_status).filled(:bool?)
  required(:tokens).filled(:int?)
end

#Schema for validating company data with Dry Schema Params
CompanySchema = Dry::Schema.Params do
  required(:id).filled(:int?)
  required(:name).filled(:str?)
  required(:top_up).filled(:int?)
  required(:email_status).filled(:bool?)
end

#User Validation Method
def validate_user(user)
  UserSchema.call(user).success?
end

#Company Validation Method
def validate_company(company)
  CompanySchema.call(company).success?
end
