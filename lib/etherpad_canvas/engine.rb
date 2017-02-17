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
        version: EtherpadCanvas::VERSION,
        settings_partial: "etherpad_canvas/plugin_settings",
      )
      require "etherpad_canvas/collaborations_controller"
    end
  end
end
