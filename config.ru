require 'bundler'

Bundler.require
ROOT = ::File.dirname(__FILE__)

require './api/v1'

run V1::App