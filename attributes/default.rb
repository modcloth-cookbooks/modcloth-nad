# Copyright (c) 2013 ModCloth, Inc.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

default['nad']['git_repo'] = 'https://github.com/circonus-labs/nad'
default['nad']['git_ref'] = '436a731b000b359e2ef6bdd07c8cec7a56923c6a'
default['nad']['install_target'] = 'install'

default['install_prefix'] = '/usr/local'
default['nad']['prefix'] = '/opt/circonus'
default['nad']['service_name'] = 'nad'
default['nad']['user'] = 'nobody'
default['nad']['group'] = 'nobody'

default['nad']['use_private_interface'] = true
default['nad']['interface']['private'] = nil

default['nad']['autofs']['shares'] = %w(
  /net/filer/export/share0
  /net/filer/export/share1
)

case node['platform']
when 'smartos', 'solaris2'
  default['nad']['service_name'] = 'circonus/nad'
  default['nad']['install_target'] = 'install-illumos'
  default['install_prefix'] = '/opt/local'
when 'ubuntu'
  default['nad']['install_target'] = 'install-linux'
  default['nad']['group'] = 'nogroup'
when 'centos'
  default['nad']['install_target'] = 'install-rhel'
end
