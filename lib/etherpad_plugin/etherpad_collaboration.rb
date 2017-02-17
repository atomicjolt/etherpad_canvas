require_dependency "app/models/etherpad_collaboration"
require "openssl"
require "base64"

class EtherpadCollaboration

  def self.sign_url(user, collaboration)
    plugin = PluginSetting.find_by(name: "etherpad_plugin")
    if !plugin.disabled
      key_pem = plugin.settings[:key]
      key = OpenSSL::PKey::RSA.new(key_pem)
      timestamp = (Time.now.to_f * 1000).to_i
      query = {
        timestamp: timestamp,
        user_id: user.id,
        username: user.name,
      }.to_query
      if collaboration.url.include?("?")
        url = collaboration.url.split("?")
        url[1] = signing(key, query)
        collaboration.url = url.join
      else
        collaboration.url += signing(key, query)
      end

      collaboration.url
    end
  end

  def signing(key, query)
    digest = OpenSSL::Digest::SHA256.new
    signature = key.sign digest, query
    encoded_signature = CGI.escape(Base64.strict_encode64(signature))
    "?#{query}&signature=#{encoded_signature}"
  end
end
