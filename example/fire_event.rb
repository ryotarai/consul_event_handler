#!/usr/bin/env ruby
require 'json'
require 'openssl'

secret = "foobar"
payload = {}.to_json
signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, payload)
payload << "|" << signature

system "consul", "event", "-name", "say-hello", payload
