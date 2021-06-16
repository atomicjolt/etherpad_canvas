# Etherpad lite Signature Authorization Plugin

## Description

This Canvas plugin allows secure sign-in and signature verification
to an Etherpad lite collaborations tool.


## Requirements:
  
1. A working etherpad-lite with the ep_signatureauth plugin installed. https://github.com/atomicjolt/ep_signatureauth
2. A self-hosted Canvas and the ability to install plugins

## Installation

Enable Etherpad in your Canvas instance by:

    Going to 'Plugins' under the settings for your account
       and enabling the Etherpad plugin
       >> Make sure to have the domain for your Etherpad instance

Ensure that 'External Collaborations Tool' is not enabled in the
Canvas Feature Options.

Change into the plugins folder and clone etherpad_canvas:

    sysadmin@appserver:~$ cd /path/to/canvas/gems/plugins
    sysadmin@appserver:/path/to/canvas/gems/plugins$ git clone https://github.com/atomicjolt/etherpad_canvas.git

Run 'bundle'

Run 'rake secret' and add the generated secret to the 
Canvas plugin settings for 'Etherpad Security'. Add the
same secret to the ep_signatureauth etherpad plugin.

## Usage

This tool is set up only to work with an instance
of Etherpad that you can add Plugins to. It is set up
to create a signed url that the accompanying Etherpad
plugin (ep_signatureauth) will verify.

## Contributing

1. Fork it!
2. Create your feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Submit a pull request :D

## History

## Credits

## License

AGPL-3.0 License
