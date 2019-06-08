#!/usr/bin/perl
use strict;
use warnings;
use URI;
use lib "lib";
use Web::Scraper;
<<<<<<< HEAD
use LWP::UserAgent;
use YAML;
use HTML::TreeBuilder;
use 5.010;
use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#print "請輸入版塊";
#my $input_forum = <STDIN>;
#chomp $input_forum;


=======
use YAML;

 
>>>>>>> origin/master
my $uri = "https://www.ptt.cc/bbs/C_Chat/index.html";
 
my $scraper = scraper {
    #process "a[href]", "urls[]" => '@href';
<<<<<<< HEAD
    process "a", "urls[]" => '@href';
    #process "div[class="date"]" =>
=======
    process 'a', "urls[]" => '@href';
>>>>>>> origin/master
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

<<<<<<< HEAD

my $line;
open (FILE,"<result.txt")||die "$!";
#open (FILE1, ">result1.txt")||die "$!";
open (FILE_, ">result_.txt")||die "$!";
open (FILE_same_title, ">result_same_title.txt")||die "$!";
open (FILE_auther, ">result_same_auther.txt")||die "$!";
open (FILE_title, ">result_title.txt")||die "$!";
=======
my $line;
open (FILE,"<result.txt")||die "$!";
open (FILE1, ">result1.txt")||die "$!";
>>>>>>> origin/master
while( defined( $line = <FILE>))
{
	if($line =~ /https/)
	{
		my @URL_ = split('::',$line);
		my @URL_add = split(' ', $URL_[1]);
<<<<<<< HEAD
		if($URL_add[1] =~ /thread/){
			print FILE_same_title "$URL_add[1]\n";
		}
		elsif($URL_add[1] =~ /author/){
			print FILE_auther "$URL_add[1]\n";
		}
		elsif($URL_add[1] =~ /M./){
			print FILE_title "$URL_add[1]\n";
		}
		else{
			print FILE_ "$URL_add[1]\n";
		}
		
=======
		print FILE1 "$URL_add[1]\n";
>>>>>>> origin/master
		#print "$URL_[2];"
	}

}
close(FILE);
<<<<<<< HEAD
#close(FILE1);
close(FILE_);
close(FILE_title);
close(FILE_auther);


my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36");
open (FILE_title, "<result_title.txt")||die "$!";
#my $Line;
while (my $Line = <FILE_title>) {
    chomp $Line;
    if ( $Line =~ /https:\/\/www.ptt.cc\/bbs\/C_Chat\/M(.*)/ ) {
        #my $head = "https://www.ptt.cc/bbs/C_Chat/M"."$1";
        my $head = "https://www.ptt.cc/bbs/C_Chat/M.1559976856.A.26E.html";
        print "目前解析網址：","$head\n";
        
        my $resp = $ua->get($Line);
        $resp = $resp->decoded_content;
        
        my $tree = HTML::TreeBuilder->new; 

        $tree->parse($resp);
        my $e = $tree->look_down(class => 'push',);
        #say $e->as_trimmed_text();

        foreach my $title ($tree->look_down(class => 'article-metaline',)) {
            #my @push = $tree->find("push");
            #return $td[1]->as_text if $td[0]->as_text eq $key;
            say $title->as_trimmed_text();
        }

        foreach my $anchor ($tree->look_down(class => 'push',)) {
            #my @push = $tree->find("push");
            #return $td[1]->as_text if $td[0]->as_text eq $key;
            say $anchor->as_trimmed_text();
        }
 		$tree->delete;
        last;
        #print "find page url : $head\n";

    } else {
            #print "no page title for url : $url\n";
    }

}
#system("awk '{print $0 > "to_file.txt"}' result.txt ");
=======
close(FILE1);
#system("awk '{print $0 > "to_file.txt"}' result.txt ");





>>>>>>> origin/master
