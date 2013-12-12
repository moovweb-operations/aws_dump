require 'aws-sdk'

module AwsDump
  class Account < Hash
    attr_accessor :options

    def initialize(name, options = {})
      @options = options
      self[:name] = name
      AWS.memoize do
        self[:regions] = regions.sort
      end
    end

    def regions
      aws.regions.collect do |region|
        Region.new(self, region)
      end
    end

    private

    def aws
      @aws ||= AWS::EC2.new(@options)
    end
  end
end
