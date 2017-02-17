require_dependency "app/controllers/collaborations_controller"
require "etherpad_plugin/etherpad_collaboration"

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
