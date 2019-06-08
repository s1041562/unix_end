#!/usr/bin/perl -w
# Perl pragma to restrict unsafe constructs
use strict;
# use LWP::UserAgent model
use LWP::UserAgent;
use HTML::TokeParser;
use Encode;
use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
 
# main function
sub main {
    #print "輸入想去看板 :";
    #my $input_forum = <STDIN>;
    #chomp $input_forum;
    #print "$input_forum";

    # get params
    # @_  
    # Within a subroutine the array @_ contains the parameters passed to that subroutine. 
    # Inside a subroutine, @_ is the default array for the array operators push, pop, shift, and unshift.
    my $url = "https://www.ptt.cc/bbs/Gossiping/index.html";
    my $validate_url = "https://www.ptt.cc/ask/over18";
    #my $url = "https://www.ptt.cc/bbs/$input_forum/index.html";
    die "no url param!\n" unless $url;
 	
    # create LWP::UserAgent object
    my $ua = LWP::UserAgent->new;
    # set connect timeout 
    #$ua->timeout(100);
    # set User-Agent header
    #$ua->agent("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; .NET CLR 2.0.50727)");
    $ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36");
    
    # use post method to verify 18 yr old
    #my $resp = $ua->post( $validate_url, verify => "False",
    #data => { 'from' => "/bbs/Gossiping/index.html" , 'yes' => "yes"});
    my $resp = $ua->post( $validate_url,
    { 'from' => "/bbs/Gossiping/index.html" , 'yes' => "yes"});
    print $resp->content; 
    
    # send url use get mothed, and store response at var $resp
    $resp = $ua->get($url);
    
 	#print "$url";
    # check response
    if ($resp->is_success) {
        # get response content(html source code)
        my $content = $resp->decoded_content;
        
        my $outfile = 'content.txt';
        open (FILE, "> $outfile");
        print FILE "$content";
        
        # use Regex get page title from $content                   
        open my $in, "<:encoding(utf8)", $outfile or die "$outfile: $!";
        while (my $line = <$in>) {
            chomp $line;
            if ( $line =~ /<a href.*>(.*)<\/a>/ ) {
                my $head = $1;
                print "find page title : $head\n";
            } else {
                #print "no page title for url : $url\n";
            }
        }
    } else {
		#display status information and exit
        die $resp->status_line;
    }

}
 
# pass params to main function,
# @ARGV
# The array @ARGV contains the command-line arguments intended for the script.
 
main(@ARGV);
