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
open (FILE, ">result/result好ｗ.txt")||die "$!";
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
   		say FILE1 "$URL_add[1]";
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
        #my $head = "https://www.ptt.cc/bbs/C_Chat/M.1559976856.A.26E.html";

        print "目前解析網址：","$head\n";

        #system("mkdir copy_art");
        open(FILE_storage ,">count.txt")||die "$!";

        my $resp = $ua->get($head);
        $resp = $resp->decoded_content;

        my $tree = HTML::TreeBuilder->new; 
        $tree->parse($resp);

        foreach my $title ($tree->look_down(class => 'article-metaline',)) {
            #my @push = $tree->find("push");
            #return $td[1]->as_text if $td[0]->as_text eq $key;
            say $title->as_trimmed_text();
            say FILE_storage $title->as_trimmed_text();
        }        


        my @values = split('\n', $resp);  
        
        my $print_content = 0;
        foreach my $val (@values) {  
            
            if($print_content eq 1){
                if($val =~ /<span/){
                    $print_content = 0;
                }else{
                    say "$val";
                    say FILE_storage $val;

                }
            }
            if($val =~ /main-content/){
                $print_content = 1;  
            }
        }  
        


        foreach my $anchor ($tree->look_down(class => 'push',)) {
            #my @push = $tree->find("push");
            #return $td[1]->as_text if $td[0]->as_text eq $key;
            my $temp = $anchor->as_trimmed_text();
            say $temp;
            say FILE_storage $temp;
        }
 
        last;
        #print "find page url : $head\n";
    } else {
            #print "no page title for url : $url\n";
    }
}
#system("awk '{print $0 > "to_file.txt"}' result.txt ");