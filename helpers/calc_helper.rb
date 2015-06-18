require 'rbnacl/libsodium'
require 'jwt'

module CalcHelper
  def authenticate_client_from_header(authorization)
    scheme, jwt = authorization.split(' ')
    ui_key = OpenSSL::PKey::RSA.new(ENV['UI_PUBLIC_KEY'])
    payload, header = JWT.decode jwt, ui_key
    @user_id = payload['sub']
    result = (scheme =~ /^Bearer$/i) && (payload['iss'] == 'https://securecalc.herokuapp.com')
    return result
  rescue
    false
  end

  def random_simple(max=nil, seed=nil)
    req_params = { max: max, seed: seed }

    new_op = Operation.new
    new_op.user_id = @user_id
    new_op.operation = 'random_simple'
    new_op.parameters = req_params.to_json
    new_op.save

    seed ||= Random.new_seed
    randomizer = Random.new(seed)
    result = max ? randomizer.rand(max) : randomizer.rand

    operation_index

    { random: result, seed: seed,
      notes: 'Simple PRNG not for secure use' }
  end

  def operation_index
    op_list = Operation
                .where(user_id: @user_id)
                .map() { |op| {name: op.operation, date: op.created_at} }
    op_index = {user_id: @user_id, operations: op_list}
    settings.ops_cache.set(@user_id, op_index.to_json)
    op_index
  end
end
