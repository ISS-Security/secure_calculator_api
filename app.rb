require 'sinatra'
require 'json'
require 'rdiscount'
require 'tilt/rdiscount'

configure :development, :test do
  require 'config_env'
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

require_relative 'model/operation'
require_relative 'helpers/calc_helper'

# Security Calculator Web Service
class SecurityCalculatorAPI < Sinatra::Base
  include CalcHelper
  enable :logging

  get '/api/v1/?' do
    'Services offered include<br>' \
    ' GET /api/v1/hash_murmur?text=[your text]<br>' \
    ' POST /api/v1/random_simple (numeric parameters: max, body)'
  end

  get '/api/v1/hash_murmur' do
    content_type :json
    plaintext = params[:text]
    halt 400 unless plaintext

    { hash: plaintext.hash,
      notes: 'Non-cryptographic hash not for secure use'
    }.to_json
  end

  post '/api/v1/random_simple' do
    content_type :json
    authenticate_client_from_header(request['AUTHORIZATION'])

    max = seed = nil
    request_json = request.body.read
    unless request_json.empty?
      req = JSON.parse(request_json)
      max = req['max']
      seed = req['seed']
    end

    random_simple(max, seed).to_json
  end

  get '/' do
    markdown :README
  end
end
