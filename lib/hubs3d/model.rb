require "base64"
require "hubs3d/api"

module Hubs3D
  class Model
    attr_reader :name, :path, :attachments

    def initialize(id: nil,
                   name: nil,
                   path: nil,
                   attachments: nil)
      @id = id
      @name = name
      @path = path
      @attachments = attachments
    end

    def id
      @id ||= post["modelId"].to_i
    end


    private

    def base_64
      Base64.encode64 open(@path, 'r') { |f| f.read }
    end

    def post
      params = {
        file: base_64,
        fileName: name,
        attachments: attachments
      }

      API.post("/model", params.delete_if { |k, v| v.nil? || v.empty? })
    end
  end
end
