require_relative 'spec_helper'

describe 'Secure Calculator API Stories' do
  describe 'Getting the root of the service' do
    it 'should return ok' do
      get '/'
      last_response.body.must_include 'Secure Calculator Web API'
      last_response.status.must_equal 200
    end
  end

  describe 'Getting hash_murmur hash' do
    it 'should return a valid hash as Fixnum' do
      get '/api/v1/hash_murmur?text=hashthistext'
      last_response.status.must_equal 200
      results = JSON.parse(last_response.body)
      results['hash'].must_be_kind_of Fixnum
    end
  end

  describe 'Getting random_simple number' do
    it 'should return a valid number as Fixnum' do
      post '/api/v1/random_simple'
      last_response.status.must_equal 200
      results = JSON.parse(last_response.body)
      rand_num = results['random']
      rand_num.must_be :>=, 0
      rand_num.must_be :<=, 1
    end

    it 'should return the same number for a fixed seed' do
      req_header = {'CONTENT_TYPE'=>'application/json'}
      req_body = {seed: 1234, max: 256}
      post '/api/v1/random_simple', req_body.to_json, req_header
      last_response.status.must_equal 200
      results = JSON.parse(last_response.body)
      rand1 = results['random']

      req_header = {'CONTENT_TYPE'=>'application/json'}
      req_body = {seed: 1234, max: 256}
      post '/api/v1/random_simple', req_body.to_json, req_header
      last_response.status.must_equal 200
      results = JSON.parse(last_response.body)
      rand2 = results['random']

      rand1.must_equal rand2
    end
  end
end
