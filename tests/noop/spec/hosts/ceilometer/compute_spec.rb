require 'spec_helper'
require 'shared-examples'
manifest = 'ceilometer/compute.pp'

describe manifest do
  shared_examples 'catalog' do
    ceilometer_hash = Noop.hiera_structure 'ceilometer'
    if ceilometer_hash['enabled']
      it 'should configure OS ENDPOINT TYPE for ceilometer' do
        should contain_ceilometer_config('service_credentials/os_endpoint_type').with(:value => 'internalURL')
      end
      event_ttl = ceilometer_hash['event_time_to_live'] ? (ceilometer_hash['event_time_to_live']) : ('604800')
      metering_ttl = ceilometer_hash['metering_time_to_live'] ? (ceilometer_hash['metering_time_to_live']) : ('604800')
      http_timeout = ceilometer_hash['http_timeout'] ? (ceilometer_hash['http_timeout']) : ('600')
      it 'should configure time to live for events and meters' do
        should contain_ceilometer_config('database/event_time_to_live').with(:value => event_ttl)
        should contain_ceilometer_config('database/metering_time_to_live').with(:value => metering_ttl)
      end
      it 'should configure timeout for HTTP requests' do
        should contain_ceilometer_config('DEFAULT/http_timeout').with(:value => http_timeout)
      end
      it 'should disable use_stderr option' do
        should contain_ceilometer_config('DEFAULT/use_stderr').with(:value => 'false')
      end
    end
  end # end of shared_examples

  test_ubuntu_and_centos manifest
end

