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
    @collaboration = @context.collaborations.find(params[:id])
    if @collaboration.collaboration_type == "EtherPad"
      return redirect_to EtherpadCollaboration.sign_url(@current_user, @collaboration)
    else
      show_without_etherpad
    end
  end

  def create
    content_item = params["contentItems"] ? JSON.parse(params["contentItems"]).first : nil
    if content_item
      @collaboration = collaboration_from_content_item(content_item)
      users, group_ids = content_item_visibility(content_item)
    else
      users = User.where(id: Array(params[:user])).to_a
      group_ids = Array(params[:group])
      collaboration_params = params.require(:collaboration).permit(:title, :description, :url)
      collaboration_params[:user] = @current_user
      @collaboration = Collaboration.typed_collaboration_instance(params[:collaboration].delete(:collaboration_type))
      collaboration_params.delete(:url) unless @collaboration.is_a?(ExternalToolCollaboration)
      @collaboration.attributes = collaboration_params
    end
    @collaboration.context = @context
    if @collaboration.collaboration_type == "EtherPad"
      respond_to do |format|
        if @collaboration.save
          Lti::ContentItemUtil.new(content_item).success_callback if content_item
          @collaboration.update_members(users, group_ids)
          format.html { redirect_to EtherpadCollaboration.sign_url(@current_user, @collaboration) }
          format.json {
            render json: @collaboration.as_json(
              methods: [:collaborator_ids], permissions: {
                user: @current_user,
                session: session,
              }
            )
          }
        else
          Lti::ContentItemUtil.new(content_item).failure_callback if content_item
          flash[:error] = t "errors.create_failed", "Collaboration creation failed"
          format.html { redirect_to named_context_url(@context, :context_collaborations_url) }
          format.json { render json: @collaboration.errors, status: :bad_request }
        end
      end
    else
      create_without_etherpad
    end
  end
end
