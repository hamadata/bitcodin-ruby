require 'json'

module Bitcodin
  class S3InputConfig

    attr_accessor :values

    def initialize(accessKey, secretKey, bucket, region, objectKey)
      hash = {type: 's3'}
      %w(accessKey secretKey bucket region objectKey).each do |param|
        hash[param] = eval(param)
      end
      @values = JSON.generate(hash)
    end

  end
end
