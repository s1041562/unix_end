#!/usr/bin/perl -w

# a simple web crawler

use strict;
use LWP::Simple;

my $url = shift || die 'Please provide an initial url after filename!';
my $max = 10;

my $html = get($url);
my @urls;
while ($url =~ s/(https:\/\/\S+)[">]//) {
        push @urls, $1;
        print @urls;
}

mkdir "web" , 0755;
open (URLMAP, ">", "web/url.map" ) || die ("can't open web\/url.map\n");
my $count = 0;

for (my $i=0; $i<$max; $i++) {
        my $source = $urls[int(rand($#urls+1))];
        getstore($source, 'web/$count.html');
        print URLMAP "$count\n$source\n";
        $count++;
}
close URLMAP;