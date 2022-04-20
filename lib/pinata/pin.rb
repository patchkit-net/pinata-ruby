module Pinata
  class Pin
    Endpoint = "https://api.pinata.cloud/pinning/"

    def self.pin_file(filename)
      uri = URI.parse(Pin::Endpoint + "pinFileToIPFS")

      request = Net::HTTP::Post.new(uri.request_uri)
      request['pinata_api_key'] = Pinata.api_key
      request['pinata_secret_api_key'] = Pinata.secret_api_key

      form_data = [['file', File.new(filename)]]
      request.set_form form_data, 'multipart/form-data'

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      return JSON.parse(response.body)
    end

    def self.remove_pin(hash)
      uri = URI.parse(Pin::Endpoint + "removePinFromIPFS")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['content-type'] = "application/json"
      request['pinata_api_key'] = Pinata.api_key
      request['pinata_secret_api_key'] = Pinata.secret_api_key
      request.body = "{
        \"ipfs_pin_hash\" : \"#{hash}\"
      }"
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        puts "Success"
      else
        return JSON.parse(response.body)
      end
    end
  end
end
