#!/usr/bin/perl
use strict;
use warnings;
use URI;
use lib "lib";
use Web::Scraper;
use LWP::UserAgent;
use YAML;

#print "請輸入版塊";
#my $input_forum = <STDIN>;
#chomp $input_forum;
my $input_forum = "C_Chat";
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
my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36");
open my $in, "<:encoding(utf8)", "result1.txt" or die "result1.txt: $!";
while (my $line = <$in>) {
    chomp $line;
    if ( $line =~ /https:\/\/www.ptt.cc\/bbs\/C_Chat\/M(.*)/ ) {
        my $head = "https://www.ptt.cc/bbs/C_Chat/M"."$1";
        my $resp = $ua->get($head);
        print $resp->decoded_content;
        last;
        #print "find page url : $head\n";
    } else {
            #print "no page title for url : $url\n";
    }
}
#system("awk '{print $0 > "to_file.txt"}' result.txt ");
