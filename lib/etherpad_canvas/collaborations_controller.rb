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

require_dependency "app/controllers/collaborations_controller"
require "etherpad_canvas/etherpad_collaboration"

class CollaborationsController
  alias show_without_etherpad show
  alias create_without_etherpad create

  def show
    show_without_etherpad
    if @collaboration.collaboration_type == "EtherPad"
      self.response_body = nil
      redirect_to EtherpadCollaboration.sign_url(@current_user, @collaboration)
    end
  end

  def create
    create_without_etherpad
    if @collaboration.collaboration_type == "EtherPad"
      respond_to do |format|
        format.html do
          self.response_body = nil
          redirect_to EtherpadCollaboration.sign_url(@current_user, @collaboration)
        end
      end
    end
  end
end
