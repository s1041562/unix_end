#!/usr/bin/perl
use strict;
use warnings;
use URI;
use lib "lib";
use Web::Scraper;
use LWP::UserAgent;
use YAML;
use HTML::TreeBuilder;
use HTML::Parser;
use 5.010;
use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#open(FILE,"<result_.txt")||die "$!";
my $url = "https://www.ptt.cc/bbs/C_Chat/index.html";
my $count = 0;

my $next = "";
open(FILE_TITLE,">TITLE.txt")||die "$!";

while($count <=10){
	open(FILE,">Result.txt")||die "$!";
	my $scraper = scraper {
    process 'a', "urls[]" => '@href';
	};

	my $links = $scraper->scrape(URI->new($url));
	my $content = Dump($links);
	print FILE "$content";
	close(FILE);

	my $line;
	#放文章網址
	open(FILE,"<Result.txt")||die "$!";
	while( defined( $line = <FILE>))
	{
		chomp $line;
		if($line =~ /https/)
		{
			my @URL_ = split('::',$line);
			my @URL_add = split(' ', $URL_[1]);
			if($URL_add[1] =~ /https:\/\/www.ptt.cc\/bbs\/C_Chat\/index([0-9][0-9].*)/){
				$url = $URL_add[1];
			}
			elsif($URL_add[1] =~ /M.*html/){
				#do nothing
				print FILE_TITLE "$URL_add[1]\n";
			}
			else{
				#print FILE_ "$URL_add[1]\n";
			}
		}	
	}
	close(FILE);
	$count = $count+1;
	#say "$count";
}
close(FILE_TITLE);


my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36");

open(FILE_,"<TITLE.txt")||die "$!";
open(FILE_TEXT,">TEXT.txt")||die "$!";
my $LINE;
while (defined ($LINE = <$FILE_>)){
    chomp $LINE;

    say "目前網址：","$LINE";

    my $resp = $ua->get($LINE);
    $resp = $resp->decoded_content;

    my $tree = HTML::TreeBuilder->new; 
    $tree->parse($resp);

    foreach my $title ($tree->look_down(class => 'article-metaline',)) {
        say FILE_TEXT $title->as_trimmed_text();
    }

    my @values = split('\n', $resp);  
        
    my $print_content = 0;
    foreach my $val (@values) {  
           
        if($print_content eq 1){
            if($val =~ /<span/){
                $print_content = 0;
            }else{
                #say "$val";
                say FILE_TEXT $val;
            }
        }
        if($val =~ /main-content/){
            $print_content = 1;  
        }
    }  

    foreach my $anchor ($tree->look_down(class => 'push',)) {

        my $temp = $anchor->as_trimmed_text();
        #say $temp;
        say FILE_TEXT $temp;
    }
    last;
}

close(FILE_TITLE);

