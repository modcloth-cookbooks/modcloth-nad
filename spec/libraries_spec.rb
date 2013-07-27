require_relative '../libraries/nad'

describe 'Nad helper libraries' do
  context 'when an ipv4 address is available' do
    before do
      Object.any_instance.stub(:`).with('ifconfig -a').and_return(<<-EOIFCONFIG.gsub(/^ {8}/, ''))
        lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
          options=3<RXCSUM,TXCSUM>
          inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1
          inet 127.0.0.1 netmask 0xff000000
          inet6 ::1 prefixlen 128
        gif0: flags=8010<POINTOPOINT,MULTICAST> mtu 1280
        stf0: flags=0<> mtu 1280
        en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
          ether 54:26:96:d3:36:75
          inet6 fe80::5321:96af:fe43:3679%en0 prefixlen 64 scopeid 0x4
          inet 192.168.1.5 netmask 0xffffff00 broadcast 192.168.1.255
          media: autoselect
          status: active
        p2p0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 2304
          ether 06:26:99:d3:32:75
          media: autoselect
          status: inactive
        vboxnet0: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
          ether 0a:10:29:0a:00:00
          inet 33.33.33.1 netmask 0xffffff00 broadcast 33.33.33.255
              EOIFCONFIG
    end

    it 'returns the address' do
      private_interface_ipv4.should == '192.168.1.5'
    end
  end
end
