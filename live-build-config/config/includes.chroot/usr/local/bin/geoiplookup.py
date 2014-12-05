#!/usr/bin/env python

import sys

import maxminddb

import subprocess

import re

import json

import getopt


#specify the ip geo db path
GeoLit2_city = "/root/getipDB/GeoLite2-City.mmdb"


#ipInfo():获得指定ip的地理信息 ，以json格式返回

def ipInfo(ip):
readerCity = maxminddb.Reader(GeoLit2_city)

cityInfo = readerCity.get(ip)
print "\033[1;33;40m"
print "%s 's Geo information:" % ip
print "\033[0m"
print json.dumps(cityInfo, sort_keys=True, indent=2)

readerCity.close()


＃hostToIP():调用外部命令host，反查域名所在ip
def hostToIP(host):
   try:
      ipInfo = subprocess.check_output(['host',host],stderr=subprocess.STDOUT,)
   except subprocess.CalledProcessError as err:
      print "ERROR:",err
   else:
      ips = re.findall(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',ipInfo)

return ips


＃hostInfo():获得指定域名的地理信息
def hostInfo(host):
   print "\033[1;31;40m"
   print "%s 's gep information: " % host
   print "\033[0m"
   ips = hostToIP(host)
   for item in ips:

ipInfo(item)chmod +x geoiplookup.py


＃usage(): 脚本帮助信息，显示各个选项的使用方法

def usage():

print "%s [-ip 61.55.186.15] [-host tanjiti.com]" % sys.argv[0]
print "\t -d or --domain : specify the host for query"
print "\t -i or --ip: specify the ip for query"
print "\t -h or --help: for more help"


＃main():主函数体

def main():
try:
opts,args = getopt.getopt(sys.argv[1:],"i:d:h",["ip=","domain=","help"])
except getopt.GetoptError as err:
print str(err)
usage()
sys.exit(2)
else:
for opt,val in opts:
if opt in ('-h','--help'):
usage()
sys.exit()
elif opt in ('-i','--ip'):
ipInfo(val)
elif opt in ('-d','--domain'):
hostInfo(val)
else:
assert False,"unhandled option"

if __name__ == "__main__":
main()
