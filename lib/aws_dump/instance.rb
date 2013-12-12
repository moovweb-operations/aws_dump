require 'aws-sdk'

module AwsDump
  class Instance < Hash
    def initialize(parent, instance)
      @parent = parent
      @instance = instance
      self[:name] = instance.tags["Name"] || instance.id
      self[:public_ip] = instance.public_ip_address
      self[:private_ip] = instance.private_ip_address
      self[:instance_type] = instance.instance_type
      self[:id] = instance.id
      self[:image_id] = instance.image_id
      self[:root_device_type] = instance.root_device_type
      self[:security_groups] = security_groups
    end

    def security_groups
      list = []
      @instance.security_groups.each do |security_group|
        list << {
          :name => security_group.name,
          :id => security_group.id
        }
      end
      list
    end

    def <=>(other)
      self[:name] <=> other[:name]
    end
  end
end
