class User
  attr_accessor :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

  def initialize(id, first_name, last_name, email, company_id, email_status, active_status, tokens)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @company_id = company_id
    @email_status = email_status
    @active_status = active_status
    @tokens = tokens
  end

  def to_h
    {
      id: @id,
      first_name: @first_name,
      last_name: @last_name,
      email: @email,
      company_id: @company_id,
      email_status: @email_status,
      active_status: @active_status,
      tokens: @tokens
    }
  end
end
