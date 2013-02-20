Description
===========
Use this cookbook to install the Node Agent Daemon (nad) on your system.  Nad acts as an extensible agent to report data back to Circonus.

Requirements
============
We currently support SmartOS only, but it should be easy to add support for other systems.  Also requires the ModCloth git and smartos cookbooks.

Attributes
==========
We set an attribute to lock the listening daemon to private interfaces only.

Attributes controlling autofs 'mounts' should be set in a role like this:

    override_attributes(
    	"autofs" => {
         "shares" => ["/net/filer/export/share0", "/net/filer/export/share1"]
       }
    )

Usage
=====
Add the cookbook to your runlist.  If you want to have the agent listen on public interfaces, modify the default.rb attributes file.
