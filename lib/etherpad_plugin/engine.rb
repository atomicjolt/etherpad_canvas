module EtherpadPlugin
  class Engine < ::Rails::Engine
    config.to_prepare do
      Canvas::Plugin.register(
        :etherpad_plugin,
        nil,
        name: -> { I18n.t(:etherpad_plugin_name, "Etherpad Security") },
        display_name: -> { I18n.t :etherpad_plugin_display, "Etherpad Security" },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, "Enable secure sign-in with Etherpad collaborations tool") },
        version: EtherpadPlugin::VERSION,
        settings_partial: "etherpad_plugin/plugin_settings",
      )
      require "etherpad_plugin/collaborations_controller"
    end
  end
end
