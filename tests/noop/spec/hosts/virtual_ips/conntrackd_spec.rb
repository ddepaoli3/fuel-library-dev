require 'spec_helper'
require 'shared-examples'
manifest = 'virtual_ips/conntrackd.pp'

describe manifest do
  test_ubuntu_and_centos manifest
end

