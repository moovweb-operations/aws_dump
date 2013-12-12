require 'aws-sdk'

module AwsDump
  class SecurityGroup < Hash
    def initialize(parent, security_group)
      @parent = parent
      @security_group = security_group
      self[:name] = security_group.name
      self[:id] = security_group.id
      self[:ingress_rules] = ingress_rules.sort
      self[:egress_rules] = egress_rules.sort
    end

    def <=>(other)
      self[:name] <=> other[:name]
    end

    def ingress_rules
      @security_group.ingress_ip_permissions.collect do |ingress|
        IpPermission.new(self, ingress)
      end
    end

    def egress_rules
      @security_group.egress_ip_permissions.collect do |egress|
        IpPermission.new(self, egress)
      end
    end
  end
end
