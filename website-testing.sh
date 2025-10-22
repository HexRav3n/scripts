#!/bin/bash

red='\033[0;31m'
clear='\033[0m'

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "CMSeek"
echo -e "${clear}"
python3 cmseek.py -u https://$1 --follow-redirect --batch -r

echo -e "${red}FOCA${clear}"
echo -e "\n"
echo -e "Run FOCA on Windows"
echo -e "\n"
echo -e "${red}"
echo "Google Dorking Manual"
echo -e "${clear}"
echo -e "\n"
echo -e "site:github.com | site:gitlab.com \"$1\""
echo -e "\n"
echo -e "site:pastebin.com | site:paste2.org | site:pastehtml.com | site:slexy.org | site:snipplr.com | site:snipt.net | site:textsnip.com | site:bitpaste.app | site:justpaste.it | site:heypasteit.com | site:hastebin.com | site:dpaste.org | site:dpaste.com | site:codepad.org | site:jsitor.com | site:codepen.io | site:jsfiddle.net | site:dotnetfiddle.net | site:phpfiddle.org | site:ide.geeksforgeeks.org | site:repl.it | site:ideone.com | site:paste.debian.net | site:paste.org | site:paste.org.ru | site:codebeautify.org | site:codeshare.io | site:trello.com \"$1\""
echo -e "\n"
echo -e "inurl:$1 \"password\" | \"keys\" | \"credentials\""
echo -e "\n"
echo -e "site:$1 ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini | ext:env"
echo -e "\n"
echo -e "site:$1:login | inurl:signin | intitle:Login | intitle:\"sign in\" | inurl:auth"
echo -e "\n"


echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Shodan Subdomains"
echo -e "${clear}"

shodan domain $1


echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Domain whois Info"
echo -e "${clear}"

whois $1

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Resolve IP Address"
echo -e "${clear}"


siteip=`dig +short $1 | grep '^[.0-9]*$'`
echo $siteip

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "IP Address whois Info"
echo -e "${clear}"

whois $siteip

echo -e "${red}"
echo -e "\n"
echo "Web Fingerprint"
echo -e "${clear}"
curl --connect-timeout 5 -I -s $1 | grep -i "server:"
curl --connect-timeout 5 -I -s https://$1 | grep -i "server:"
curl --connect-timeout 5 -I -s https://$1 | grep -i "X-Served-By:"
curl --connect-timeout 5 -I -s https://$1 | grep -i "X-Powered-By:"
curl --connect-timeout 5 -I -s https://$1 | grep -i "X-Aspnet-Version:"

echo -e "${red}"
echo -e "\n"
echo "Raw Headers HTTP"
echo -e "${clear}"
curl --connect-timeout 5 -I -s http://$1

echo -e "${red}"
echo -e "\n"
echo "Raw Headers HTTPS"
echo -e "${clear}"
curl --connect-timeout 5 -I -s https://$1

echo -e "${red}"
echo -e "\n"
echo "X-Frame-Options (Clickjacking Protection)"
echo -e "${clear}"
curl --connect-timeout 5 -I -s https://$1 | grep -i "X-Frame-Options:"

echo -e "${red}"
echo "Robots"
echo -e "${clear}"
curl --connect-timeout 5 -s https://$1/robots.txt

echo -e "${red}"
echo "Apple Site Association"
echo -e "${clear}"
curl --connect-timeout 5 -s https://$1/.well-known/apple-app-site-association


echo -e "${red}"
echo "VHost Enumeration"
echo -e "${clear}"
echo "Manually run this"
echo "ffuf -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt -H \"Host: FUZZ.$1\" -u https://$1"

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Feroxbuster"
echo -e "${clear}"
feroxbuster -k -A -w /usr/share/wordlists/combined-wordlist.txt -u https://$1 -t 50
feroxbuster -A -w /usr/share/wordlists/combined-wordlist.txt -u http://$1 -t 50

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Dirsearch"
echo -e "${clear}"
dirsearch -u http://$1 --full-url --crawl
dirsearch -u https://$1 --full-url --crawl

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running Nikto"
echo -e "${clear}"
nikto -h https://$1

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Rustscan"
echo -e "${clear}"
rustscan --ulimit 5000 -a $1 -- -sC -sV

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Katana Scan"
echo -e "${clear}"
katana -u $1 -jc -d 5 -fs fqdn

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo -e "Running Nuclei"
echo -e "${clear}"
nuclei -u $1 -nmhe

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo -e "Checking SSL"
echo -e "${clear}"
/opt/testssl.sh/testssl.sh https://$1

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Cookies"
echo -e "${clear}"
echo -e "\n"
curl --connect-timeout 5 -s -D- https://$1 | grep Set-Cookie:

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running Shcheck"
echo -e "${clear}"
shcheck.py https://$1 -d

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running wafw00f"
echo -e "${clear}"
wafw00f https://$1

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running WaybackURLS"
echo -e "${clear}"
echo "$1" | waybackurls | grep -v -E '\.png|\.gif|\.jpg|\.ico|\.svg|\.css(\?v=[0-9\.]+)?'

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running Postleaks"
echo -e "${clear}"
postleaks -k $1

echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running Whatweb"
echo -e "${clear}"
whatweb https://$1
whatweb http://$1


echo -e "\n"
echo -e "\n"
echo -e "${red}"
echo "Running clickjacking test"
echo -e "${clear}"

cat <<EOF > clickjacktest.$1.html
<html>
<head>
<title>Clickjack Test Page</title>
</head>
<body>
<p>This site is vulnerable to clickjacking!</p>
<iframe src="https://$1" width="500" height="500"></iframe>
</body>
</html>
EOF

firefox clickjacktest.$1.html
