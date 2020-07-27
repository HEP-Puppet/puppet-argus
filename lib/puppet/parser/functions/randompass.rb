# Creates random password
Puppet::Parser::Functions.create_function(:randompass) do
  # @return [String] random password
  # @example
  #     randompass()  => '!@#sfsdf'
  def randompass
    length = 10
    allowed = []
    ('!'..'Z').each { |c| allowed << c }
    ('a'..'z').each { |c| allowed << c }
    value = ''
    length.times { value << allowed[rand(allowed.length)] }
    value
  end
end
