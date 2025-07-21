#!/bin/sh

echo ""
echo ""
echo ""
echo ""
echo ""
echo "-----------------------------------"
echo -e "\e[32mZapret Install\e[0m"
echo "-----------------------------------"
echo ""
echo ""
echo ""
echo ""
echo ""

# 1. Созда b l  aк `ип b дл o ав bома bи gе aкого пол c gени o кон dига
cat > /etc/init.d/getdomains << EOF
#!/bin/sh /etc/rc.common

START=99

start () {
    echo "Checking sing-box status..."
    VPN_NOT_WOKRING=\$(sing-box -c /etc/sing-box/config.json tools fetch instagram.com 2>&1 | grep FATAL)
    if [ -z "\${VPN_NOT_WOKRING}" ]
    then

        DOMAINS=https://raw.githubusercontent.com/AnotherProksY/allow-domains-no-youtube/main/Russia/inside-dnsmasq-nfset.lst
    else

        DOMAINS=https://raw.githubusercontent.com/AnotherProksY/allow-domains/main/Russia/inside-dnsmasq-nfset.lst
    fi

    count=0
    max_retries=5
    while [ \$count -lt \$max_retries ]; do
        if curl -m 3 github.com; then
            echo "GitHub is available, downloading domains list..."
            curl -f \$DOMAINS --output /tmp/dnsmasq.d/domains.lst
            break
        else
            echo "GitHub is not available. Check the internet availability [\$count]"
            count=\$((count+1))
            sleep 5
        fi
    done

    if [ \$count -eq \$max_retries ]; then
        echo "Failed to connect to GitHub after \$max_retries attempts. Exiting."
        exit 1
    fi

    echo "Checking dnsmasq configuration..."
    if dnsmasq --conf-file=/tmp/dnsmasq.d/domains.lst --test 2>&1 | grep -q "syntax check OK"; then
        echo "dnsmasq configuration is OK, restarting dnsmasq..."
        /etc/init.d/dnsmasq restart
    else
        echo "dnsmasq configuration contains errors. Please check the domains.lst file."
        exit 1
    fi
}

EOF

#  tаем п `ава на в kполнение
chmod +x /etc/init.d/getdomains

#  ~бновл oем паке b k
echo "Updating packages..."
opkg update

# Ска gиваем и  c a bанавливаем паке b k
echo "Downloading and installing zapret..."
wget -O /tmp/zapret.ipk https://github.com/ritascarlet/zapretforinstallax3000t/raw/refs/heads/main/zapret.ipk
wget -O /tmp/luciapp.ipk https://github.com/ritascarlet/zapretforinstallax3000t/raw/refs/heads/main/luciapp.ipk

if opkg install /tmp/zapret.ipk; then
    echo "Zapret installed successfully."
else
    echo "Failed to install Zapret."
    exit 1
fi

if opkg install /tmp/luciapp.ipk; then
    echo "LuCI app installed successfully."
else
    echo "Failed to install LuCI app."
    exit 1
fi

# Удал oем в `еменн kе  dайл k
rm /tmp/zapret.ipk
rm /tmp/luciapp.ipk

/etc/init.d/getdomains enable

/etc/init.d/getdomains start

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
