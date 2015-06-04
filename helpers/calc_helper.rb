require 'rbnacl/libsodium'
require 'jwt'

module CalcHelper
  def authenticate_client_from_header(authorization)
    logger.info "AUTHORIZATION: #{authorization}"
    scheme, jwt = authorization.split(' ')
    ui_key = OpenSSL::PKey::RSA.new(ENV['UI_PUBLIC_KEY'])
    payload = JWT.decode jwt, ui_key
    logger.info "PAYLOAD: #{payload}"
    result = (scheme =~ /^Bearer$/i) && (payload['iss'] == 'https://securecalc.herokuapp.com')
    logger.info "RESULT: #{result}"
    return result
  rescue
    false
  end

  def random_simple(max=nil, seed=nil)
    req_params = { max: max, seed: seed }

    seed ||= Random.new_seed
    randomizer = Random.new(seed)
    result = max ? randomizer.rand(max) : randomizer.rand

    { random: result, seed: seed,
      notes: 'Simple PRNG not for secure use' }
  end

  def encrypt_message(message)
    key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
    secret_box = RbNaCl::SecretBox.new(key)
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    nonce_s = Base64.urlsafe_encode64(nonce)
    message_enc = secret_box.encrypt(nonce, message.to_s)
    message_enc_s = Base64.urlsafe_encode64(message_enc)
    Base64.urlsafe_encode64({'message'=>message_enc_s, 'nonce'=>nonce_s}.to_json)
  end

  def decrypt_message(secret_message)
    key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
    secret_box = RbNaCl::SecretBox.new(key)
    message_h = JSON.parse(Base64.urlsafe_decode64(secret_message))
    message_enc = Base64.urlsafe_decode64(message_h['message'])
    nonce = Base64.urlsafe_decode64(message_h['nonce'])
    message = secret_box.decrypt(nonce, message_enc)
  rescue
    raise "INVALID ENCRYPTED MESSAGE"
  end
end
