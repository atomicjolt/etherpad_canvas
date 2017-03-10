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
      key = plugin.settings[:key]

      url = generate_url user, collaboration

      url_sans_http = url.split('9001')[1]

      digest = OpenSSL::Digest.new('sha1')

      hmac = OpenSSL::HMAC.hexdigest(digest, key, url_sans_http)

      "#{url}&signature=#{hmac}"
    end
  end

  def self.generate_url user, collaboration
    timestamp = (Time.now.to_f * 1000).to_i
    query = {
      timestamp: timestamp,
      user_id: user.id,
      username: user.name,
    }.to_query

    "#{collaboration.url}?#{query}"
  end
end
