require "sinatrails/version"

require "sinatrails/callbacks"
require "sinatrails/router"
require "sinatrails/controller"

require 'sinatra/base'

require 'json'
require 'active_support/ordered_options'

class Sinatra::Base
  before do
    body = request.body.read
    params.merge! indifferent_params(JSON.parse(body)) if body != ""
    logger.info "Parameters: #{params}"
  end

  def self.draw_routes &block
    Sinatrails::Router.new(self).instance_eval &block
  end

  def self.secrets
    @secrets ||= read_opts settings.secrets_file
  end

  def self.mailer
    @mailer ||= read_opts settings.mailer_file
  end

  def self.read_opts file
    opts = ActiveSupport::OrderedOptions.new
    env_opts = YAML.load(IO.read(file))[settings.environment.to_s]

    opts.merge! env_opts.symbolize_keys
    opts
  end
end
