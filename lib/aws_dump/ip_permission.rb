require 'aws-sdk'


module AwsDump
  class IpPermission < Hash
    def initialize(security_group, ip_permission)
      @security_group = security_group
      @ip_permission = ip_permission
      self[:protocol] = ip_permission.protocol
      self[:port_range] = ip_permission.port_range
      self[:groups] = groups
      self[:ip_ranges] = ip_ranges.sort
    end

    def protocol_port_range
      "#{self[:protocol]}-#{self[:port_range]}"
    end

    def <=>(other)
      protocol_port_range <=> other.protocol_port_range
    end

    def groups
      @ip_permission.groups.collect do |group|
        {
          :name => group.name,
          :id => group.id
        }
      end
    end

    def ip_ranges
      @ip_permission.ip_ranges.collect do |ip_range|
        ip_range
      end
    end
  end
end
