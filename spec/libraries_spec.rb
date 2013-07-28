require_relative '../libraries/nad'

describe 'Nad helper libraries' do
  context 'when an ipv4 address is available' do
    let(:ifconfig_a) { '' }

    before do
      Object.any_instance.stub(:`).with('ifconfig -a').and_return(ifconfig_a)
    end

    context 'on ubuntu' do
      let :ifconfig_a do
        <<-EOIFCONFIG.gsub(/^ {10}/, '')
          eth0      Link encap:Ethernet  HWaddr 08:10:a7:fa:8e:92
                    inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
                    inet6 addr: fe80::a00:27ff:feda:8897/64 Scope:Link
                    UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                    RX packets:65187 errors:0 dropped:0 overruns:0 frame:0
                    TX packets:19787 errors:0 dropped:0 overruns:0 carrier:0
                    collisions:0 txqueuelen:1000
                    RX bytes:50956417 (50.9 MB)  TX bytes:1132159 (1.1 MB)

          eth1      Link encap:Ethernet  HWaddr 08:10:28:d3:a9:c1
                    inet addr:33.33.33.10  Bcast:33.33.33.255  Mask:255.255.255.0
                    inet6 addr: fe80::a00:27ff:fec3:69c5/64 Scope:Link
                    UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
                    RX packets:0 errors:0 dropped:0 overruns:0 frame:0
                    TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
                    collisions:0 txqueuelen:1000
                    RX bytes:0 (0.0 B)  TX bytes:468 (468.0 B)

          lo        Link encap:Local Loopback
                    inet addr:127.0.0.1  Mask:255.0.0.0
                    inet6 addr: ::1/128 Scope:Host
                    UP LOOPBACK RUNNING  MTU:16436  Metric:1
                    RX packets:54 errors:0 dropped:0 overruns:0 frame:0
                    TX packets:54 errors:0 dropped:0 overruns:0 carrier:0
                    collisions:0 txqueuelen:0
                    RX bytes:4468 (4.4 KB)  TX bytes:4468 (4.4 KB)
        EOIFCONFIG
      end

      it 'returns the address' do
        private_interface_ipv4.should == '10.0.2.15'
      end
    end

    context 'on smartos' do
      let :ifconfig_a do
        <<-EOIFCONFIG.gsub(/^ {10}/, '')
          lo0: flags=2001000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv4,VIRTUAL> mtu 8232 index 1
                  inet 127.0.0.1 netmask ff000000
          net0: flags=40201000843<UP,BROADCAST,RUNNING,MULTICAST,IPv4,CoS,L3PROTECT> mtu 1500 index 2
                  inet 192.168.1.9 netmask fffffc00 broadcast 192.168.1.255
          lo0: flags=2002000849<UP,LOOPBACK,RUNNING,MULTICAST,IPv6,VIRTUAL> mtu 8252 index 1
                  inet6 ::1/128
        EOIFCONFIG
      end

      it 'returns the address' do
        private_interface_ipv4.should == '192.168.1.9'
      end
    end
  end
end
