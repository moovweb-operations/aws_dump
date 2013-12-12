require 'aws-sdk'

module AwsDump
  class Region < Hash
    attr_accessor :account

    def initialize(account, region)
      @account = account
      @region = region
      self[:name] = region.name
      self[:vpcs] = vpcs.sort
      self[:instances] = instances.sort
      self[:security_groups] = security_groups.sort
      self[:rds_instances] = rds_instances
    end

    def <=>(other)
      self[:name] <=> other[:name]
    end

    def vpcs
      @region.vpcs.collect do |vpc|
        VPC.new(self, vpc)
      end
    end

    def rds_instances
      rds = AWS::RDS.new(@account.options.merge(:region => self[:name]))
      rds.instances.collect do |instance|
        unless instance.vpc_id
          RDSInstance.new(self, instance)
        end
      end.compact
    end

    def instances
      @region.instances.collect do |instance|
        unless instance.subnet_id
          Instance.new(self, instance)
        end
      end.compact
    end

    def security_groups
      @region.security_groups.collect do |security_group|
        unless security_group.vpc_id
          SecurityGroup.new(self, security_group)
        end
      end.compact
    end
  end
end
