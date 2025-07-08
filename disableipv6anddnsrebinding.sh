#!/bin/sh

echo ""
echo ""
echo ""
echo ""
echo ""
echo "-----------------------------------"
echo -e "\e[32mDisable IP v6 and DNS Rebinding\e[0m"
echo "-----------------------------------"
echo ""
echo ""
echo ""
echo ""
echo ""


cat > /etc/config/wireless << EOF
config wifi-device 'radio0'
        option type 'mac80211'
        option path 'platform/18000000.wifi'
        option channel '1'
        option band '2g'
        option htmode 'HE20'
        option disabled '0'
        option country 'US'
        option cell_density '0'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'OfficialVPN_2G'
        option encryption 'psk2'
        option key '12345678'

config wifi-device 'radio1'
        option type 'mac80211'
        option path 'platform/18000000.wifi+1'
        option channel '36'
        option band '5g'
        option htmode 'HE80'
        option disabled '0'
        option country 'US'
        option cell_density '0'

config wifi-iface 'default_radio1'
        option device 'radio1'
        option network 'lan'
        option mode 'ap'
        option ssid 'OfficialVPN_5G'
        option encryption 'psk2'
        option key '12345678'
EOF


# Отключаем dns rebinding
cat > /etc/config/dhcp << EOF
config dnsmasq
        option domainneeded '1'
        option localise_queries '1'
        option rebind_protection '0'
        option local '/lan/'
        option domain 'lan'
        option expandhosts '1'
        option cachesize '1000'
        option authoritative '1'
        option readethers '1'
        option leasefile '/tmp/dhcp.leases'
        option localservice '1'
        option ednspacket_max '1232'
        option confdir '/tmp/dnsmasq.d'
        option noresolv '1'
        list server '127.0.0.1#5453'
        list server '/use-application-dns.net/'

config dhcp 'lan'
        option interface 'lan'
        option start '100'
        option limit '150'
        option leasetime '12h'
        option dhcpv4 'server'

config dhcp 'wan'
        option interface 'wan'
        option ignore '1'

config odhcpd 'odhcpd'
        option maindhcp '0'
        option leasefile '/tmp/hosts/odhcpd'
        option leasetrigger '/usr/sbin/odhcpd-update'
        option loglevel '4'

config ipset
        list name 'vpn_domains'
        option table_family 'inet'
        list domain 'whatismyipaddress.com'

EOF

# Отключаем ip v6
service dnsmasq restart
service network restart

echo ""
echo ""
echo ""
echo ""
echo ""
echo "-----------------------------------"
echo -e "\e[32mDone!!!\e[0m"
echo "-----------------------------------"
echo ""
echo ""
echo ""
echo ""

exit
