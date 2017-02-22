# Copyright (C) 2017 Atomic Jolt

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_dependency "app/models/etherpad_collaboration"
require "openssl"
require "base64"

class EtherpadCollaboration

  def self.sign_url(user, collaboration)
    plugin = PluginSetting.find_by(name: "etherpad_canvas")
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
