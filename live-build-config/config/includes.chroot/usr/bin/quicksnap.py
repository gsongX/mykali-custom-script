#!/usr/bin/python 

# quicksnap - A python script to make your scanning easier based on Zenmap and 3 Common Firewall Detection / Evasion Techniques

#Reference: http://nmap.org/book/zenmap-scanning.html
#Prerequisite: Nmap 

# - by scryptz0 of soldierx.com
#    **********************************************************************
#    |  The author hereby grants permission to reproduce, redistribute,   |
#    |  or include this file in your file section, electronic or print    |
#    |  newletter, or any other form of transmission that you choose, as  |
#    |  long as it is kept intact and whole, with no ommissions, delet-   |
#    |  ions, or changes.  (C)2013 SOLDIERX.COM - http://www.soldierx.com |
#    |      > Author's E-mail - scryptz0@soldierx.com    		          |
#    **********************************************************************

#Library
import os

#Color For Terminal
r = '\033[31m' #red
b = '\033[34m' #blue
g = '\033[32m' #green

print ""
print g + "SOLDIERX.COM - Nobody Can Stop Information Insemination"
print ""

print b+ "##################################################"
print "# quicksnap - A Customized Nmap Automatic Scanner#"
print "##################################################"
print ""

print r+ "Scanning Options"
print "[1] Intense Scan"
print "[2] Intense Scan + UDP"
print "[3] Intense Scan - all TCP ports"
print "[4] Intense Scan w/out ping"
print "[5] Ping Scan"
print "[6] Quickie Scan"
print "[7] Quick Traceroute"
print "[8] Normal Scan"
print "[9] Send Bad Checksums"
print "[10] Generate Randon Mac Adress Spoofing for Evasion"
print "[11] Fragment Packets"
print "[12] Check for Possible Vulnerabilities"

option = raw_input("Choose your Scanning Option:")

print g+ ""

if option == '1':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -T4 -A -v "+ip)
elif option == '2':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -sS -sU -T4 -A -v "+ip)
elif option == '3':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -p 1-65535 -T4 -A -v "+ip)
elif option == '4':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -T4 -A -v -Pn "+ip)
elif option == '5':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -sn "+ip)
elif option == '6':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -T4 -F "+ip)
elif option == '7':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -sn --traceroute "+ip)
elif option == '8':
   ip = raw_input("Input IP Address / Hostname:")
elif option == '9':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap --badsum "+ip)
elif option == '10':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -sT -Pn --spoofmac 0 "+ip)
elif option == '11':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap -f "+ip)
elif option == '12':
   ip = raw_input("Input IP Address / Hostname:")
   os.system("nmap --script vuln "+ip)
else:
	print b+ "Your Choice is Invalid"
	print "Goodbye"
	print " I don't loop :p"
