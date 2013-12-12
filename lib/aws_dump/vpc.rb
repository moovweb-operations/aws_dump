require 'aws-sdk'

module AwsDump
  class VPC < Hash
    def initialize(region, vpc)
      @region = region
      @vpc = vpc
      self[:name] = vpc.tags["Name"]
      self[:instances] = instances.sort
      self[:security_groups] = security_groups.sort
      self[:rds_instances] = rds_instances
    end

    def <=>(other)
      self[:name] <=> other[:name]
    end

    def instances
      @vpc.instances.collect do |instance|
        Instance.new(self, instance)
      end
    end

    def security_groups
      @vpc.security_groups.collect do |security_group|
        SecurityGroup.new(self, security_group)
      end.compact
    end

    def rds_instances
      rds = AWS::RDS.new(@region.account.options.merge(:region => @region[:name]))
      rds.instances.collect do |instance|
        unless instance.vpc_id == @vpc.id
          RDSInstance.new(self, instance)
        end
      end.compact
    end
  end
end
