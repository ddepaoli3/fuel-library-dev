require 'ipaddr'
require 'zlib'

module Puppet::Parser::Functions
  newfunction(:create_dnsmasq_dhcp_ranges, :doc => <<-EOS
Creates nailgun::dnsmasq::dhcp_range puppet resources from list of admin networks.
  EOS
) do |args|
    admin_nets = args[0]
    unless admin_nets.is_a?(Array) and admin_nets[0].is_a?(Hash)
      raise(Puppet::ParseError, 'Should pass list of hashes as a parameter')
    end
    admin_nets.each do |net|
      net['ip_ranges'].each do |ip_range|
        netmask = IPAddr.new('255.255.255.255').mask(net['cidr'].split('/')[1]).to_s
        print_range = ip_range.join('_')
        resource_name = sprintf("range_%08x", Zlib::crc32("#{print_range}_#{net['cidr']}").to_i)
        range_comment = "# Environment: #{net['cluster_name']}\n# Nodegroup: #{net['node_group_name']}\n# IP range: #{ip_range}"
        dhcp_range_resource = {
          resource_name => {
            'file_header'        => "# Generated automatically by puppet\n#{range_comment}",
            'dhcp_start_address' => ip_range[0],
            'dhcp_end_address'   => ip_range[1],
            'dhcp_netmask'       => netmask,
            'dhcp_gateway'       => net['gateway'],
          }
        }
        debug("Trying to create nailgun::dnsmasq::dhcp_range resource #{dhcp_range_resource}")
        function_create_resources(['nailgun::dnsmasq::dhcp_range', dhcp_range_resource])
      end
    end
  end
end
