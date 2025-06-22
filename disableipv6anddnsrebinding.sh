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
