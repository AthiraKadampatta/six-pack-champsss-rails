class GoogleValidatorService
  attr_reader :id_token
  attr_accessor :validator

  def initialize(id_token)
    @id_token = id_token
    @validator = GoogleIDToken::Validator.new
  end

  def call
    return false unless @id_token
    validate
  end

  private

  def validate
    aud = JWT.decode(@id_token, nil, false)[0]['aud']
    payload = @validator.check(@id_token, aud)
  rescue GoogleIDToken::ValidationError => e
    raise "unauthorized"
  end
end
