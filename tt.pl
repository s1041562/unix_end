#!/usr/bin/perl
use strict;
use warnings;
use URI;
use lib "lib";
use Web::Scraper;
use YAML;

 
my $uri = "https://www.ptt.cc/bbs/C_Chat/index.html";
 
my $scraper = scraper {
    #process "a[href]", "urls[]" => '@href';
    process 'a', "urls[]" => '@href';
    #//*[@id="main-container"]/div[2]/div[2]/div[2]/a

    #result 'urls';
};

my $links = $scraper->scrape(URI->new($uri));
#print Dump $links;
my $content = Dump($links);
#print ($content);
open (FILE, ">result.txt")||die "$!";
print FILE "$content";
close(FILE);

my $line;
open (FILE,"<result.txt")||die "$!";
open (FILE1, ">result1.txt")||die "$!";
while( defined( $line = <FILE>))
{
	if($line =~ /https/)
	{
		my @URL_ = split('::',$line);
		my @URL_add = split(' ', $URL_[1]);
		print FILE1 "$URL_add[1]\n";
		#print "$URL_[2];"
	}

}
close(FILE);
close(FILE1);
#system("awk '{print $0 > "to_file.txt"}' result.txt ");





