#!/usr/bin/perl -w
# Perl pragma to restrict unsafe constructs
use strict;
# use LWP::UserAgent model
use LWP::UserAgent;
 
# main function
sub main {
    print "輸入想去看板 :";
    my $input_forum = <STDIN>;
    print "$input_forum";

    # get params
    # @_  
    # Within a subroutine the array @_ contains the parameters passed to that subroutine. 
    # Inside a subroutine, @_ is the default array for the array operators push, pop, shift, and unshift.
    #my $url = 'https://www.ptt.cc/bbs/Gossiping/index.html';
    my $url = "https://www.ptt.cc/bbs/$input_forum/index.html";
    die "no url param!\n" unless $url;
 	print "$url";
    # create LWP::UserAgent object
    my $ua = LWP::UserAgent->new;
    # set connect timeout 
    $ua->timeout(20);
    # set User-Agent header
    $ua->agent("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; .NET CLR 2.0.50727)");
    # send url use get mothed, and store response at var $resp
    my $resp = $ua->get($url);
 
    # check response
    if ($resp->is_success) {
        # get response content(html source code)
        my $content = $resp->decoded_content;
        # use Regex get page title from $content
        if ( $content =~ m{<title>(.*)</title>}si ) {
            # <title>(.+?)</title> (.+?) match title string, use () to store this str at a special variable $1 (this is a perl variable ),
            # The bracketing construct ( ... ) creates capture groups (also referred to as capture buffers). To refer to the current contents of a group later on, within the same pattern, use $1 for the first,$2 for the second, and so on.
            my $head = $1;
            print "find page title : $head\n";
        } else {
            print "no page title for url : $url\n";
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

