require 'aws-sdk'

module AwsDump
  class RDSInstance < Hash
    def initialize(parent, rds)
      @parent = parent
      @rds = rds
      self[:id] = @rds.id
      self[:name] = @rds.db_name
    end
  end
end
