#!/bin/sh

cat > /etc/init.d/getdomains << 'EOF'
#!/bin/sh /etc/rc.common

START=99

start () {

    rm /etc/sing-box/config.json

    DOMAINS=https://raw.githubusercontent.com/Official-VPN/Routers-domains/main/Russia/inside-dnsmasq-nfset.lst
    count=0
    while true; do
        if curl -m 3 github.com; then
            curl -f $DOMAINS --output /tmp/dnsmasq.d/domains.lst
            break
        else
            echo "GitHub is not available. Check the internet availability [$count]"
            count=$((count+1))
        fi
    done

    if dnsmasq --conf-file=/tmp/dnsmasq.d/domains.lst --test 2>&1 | grep -q "syntax check OK"; then
        /etc/init.d/dnsmasq restart
    fi
}
EOF

chmod +x /etc/init.d/getdomains

./etc/init.d/getdomains start

cat /etc/sing-box/config.json
