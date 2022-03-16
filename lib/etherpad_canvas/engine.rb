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

module EtherpadCanvas
  class Engine < ::Rails::Engine
    config.to_prepare do
      Canvas::Plugin.register(
        :etherpad_canvas,
        nil,
        name: -> { I18n.t(:etherpad_canvas_name, "Etherpad Security") },
        display_name: -> { I18n.t :etherpad_canvas_display, "Etherpad Security" },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, "Enable secure sign-in with Etherpad collaborations tool") },
        version: EtherpadCanvas::Version,
        settings_partial: "etherpad_canvas/plugin_settings",
      )
      require "etherpad_canvas/collaborations_controller"
    end
  end
end
