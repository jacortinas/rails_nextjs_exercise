# typed: true

class ApplicationRecord < ActiveRecord::Base
  sig { params(fields: T.untyped).void }
  def self.monetize(*fields); end
end