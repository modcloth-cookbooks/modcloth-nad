name             'modcloth-nad'
maintainer       'ModCloth, Inc.'
maintainer_email 'github+nad-cookbook@modcloth.com'
license          'MIT'
description      'Installs/Configures nad'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

%w(
  centos
  smartos
  solaris2
  ubuntu
).each do |os|
  supports os
end

suggests 'git'
suggests 'build-essential'
suggests 'nodejs'
