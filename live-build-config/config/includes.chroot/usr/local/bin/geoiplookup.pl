#!/usr/bin/perl -w
use Getopt::Long;
use Term::ANSIColor qw(:constants);

#命令行选项部分
my $help = "";
my $ip = "";
my $host = "";

local $Term::ANSIColor::AUTORESET = 1;

GetOptions(
'help|h'=>\$help,
'ip=s'=>\$ip,
'host=s'=>\$host
);


if($help){
print <<__HELP__;
Usage: $0 -ip 61.55.186.15 -host tanjiti.com

where:
-ip : Specify the ip address to query
-host: Specify the host address to query

__HELP__
exit 0;

}

chomp $ip;

die "You need to specify the ip address or hostname to query!!!! " if  ($ip eq "" and $host eq "");

#查询指定ip的地理信息
#query the specify ip geo information
geoiplookup($ip) if $ip ne "";

#查询指定host的地理信息
#query the specify host geo information
if ($host){
   my $ips=hosttoIP($host); 

   my @ips = split(' ',$ips);
   
   print BOLD RED "$host GEO information: \n";

   foreach (@ips){
      geoiplookup($_);
   }
}


#hosttoIP子函数：host反查获的域名对应的ip
sub hosttoIP{
   my $host = shift;
   my $ips = `host $host  | awk '{i=1; if(NF>0) do {if (\$i ~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/) print \$i; i++;} while (i <=NF);}'`;
   return $ips;
}

#geoiplookup子函数,调用geoiplookup与对应的地理数据库获得指定ip的地理信息
sub  geoiplookup{
   my $ip = shift;
   chomp $ip;

   my $country = `geoiplookup -f /usr/share/GeoIP/GeoIP.dat $ip`;
   my $city = `geoiplookup -f /usr/share/GeoIP/GeoLiteCity.dat $ip`;
   my $ASNum = `geoiplookup -f /usr/share/GeoIP/GeoIPASNum.dat $ip`;

   print BOLD BLUE "$ip GEO information: \n";
   print "\t",$country;
   print "\t",$city;
   print "\t",$ASNum;
}
