# To parse:
#
# vars = Vars.from_json! <input>
# puts vars.first.variable_type
#

require 'json'
require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types(default: :nominal)

  Bool   = Strict::Bool
  Hash   = Strict::Hash
  String = Strict::String
end

class Var < Dry::Struct
  attribute :variable_type,     Types::String
  attribute :key,               Types::String
  attribute :value,             Types::String
  attribute :protected,         Types::Bool
  attribute :masked,            Types::Bool
  attribute :environment_scope, Types::String

  def self.from_dynamic!(d)
    d = Types::Hash[d]
    new(
      variable_type:     d.fetch("variable_type"),
      key:               d.fetch("key"),
      value:             d.fetch("value"),
      protected:         d.fetch("protected"),
      masked:            d.fetch("masked"),
      environment_scope: d.fetch("environment_scope"),
    )
  end

  def self.from_json!(json)
    from_dynamic!(JSON.parse(json))
  end

  def to_dynamic
    {
      "variable_type"     => @variable_type,
      "key"               => @key,
      "value"             => @value,
      "protected"         => @protected,
      "masked"            => @masked,
      "environment_scope" => @environment_scope,
    }
  end

  def to_json(options = nil)
    JSON.generate(to_dynamic, options)
  end
end

class Vars
  def self.from_json!(json)
    vars = JSON.parse(json, quirks_mode: true).map { |x| Var.from_dynamic!(x) }
    vars.define_singleton_method(:to_json) do
      JSON.generate(self.map { |x| x.to_dynamic })
    end
    vars
  end
end
