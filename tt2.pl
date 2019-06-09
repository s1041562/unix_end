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

# 確保輸入輸出都使用utf-8格式
use utf8;
use open ':std', ':encoding(UTF-8)';
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $url = "https://www.ptt.cc/bbs/C_Chat/index.html";
my $count = 0;

my $next = "";
open(FILE_TITLE,">TITLE.txt")||die "$!";
print "輸入欲爬取版塊頁數: ";
$count=<STDIN>;
my $n = 1;
while($n <= $count){
	open(FILE,">Result.txt")||die "$!";
	
	# 初始化Webscraper
	# 將原始碼中標籤是a class, href的網址都存取放入Result.txt
	my $scraper = scraper {
    process 'a', "urls[]" => '@href';
	};

	my $links = $scraper->scrape(URI->new($url));
	my $content = Dump($links);
	print FILE "$content";
	close(FILE);

	my $line;

	open(FILE,"<Result.txt")||die "$!";
	# 一行一行從Result.txt讀入資料,準備進一步分析
	while( defined( $line = <FILE>))
	{
		chomp $line;
		if($line =~ /https/)
		{
			my @URL_ = split('::',$line);
			my @URL_add = split(' ', $URL_[1]);
			# 擷取含有文章內容的該網址
			if($URL_add[1] =~ /https:\/\/www.ptt.cc\/bbs\/C_Chat\/index([0-9][0-9].*)/){
				$url = $URL_add[1];
			}
			elsif($URL_add[1] =~ /M.*html/){
				# 將擷取的網址放入TITLE.txt
				print FILE_TITLE "$URL_add[1]\n";
			}
			else{
				# do nothing
			}
		}	
	}
	close(FILE);
	say "爬取ptt第",$n,"頁的所有文章中";
	$n = $n+1;
}
close(FILE_TITLE);

# 新增UserAgent, 可以和網頁來進行互動
my $ua = LWP::UserAgent->new;
# 將UserAgent偽裝成瀏覽器
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36");

my $num = 0;
open(FILE_,"<TITLE.txt")||die "$!";
system("mkdir copy_art");

my $no_title_text = 1;
my $LINE;
# 從title.txt讀取網址
while (defined ($LINE = <FILE_>)){
    my $filename_by_title;
    chomp $LINE;
    # 告訴使用者目前分析的文章網址
    # say "目前網址：","$LINE";
    
    # 使用UserAgent傳送Get請求並接收回傳的網頁原始碼
    my $resp = $ua->get($LINE);
    $resp = $resp->decoded_content;
    
    # 新增TreeBuilder
    my $tree = HTML::TreeBuilder->new; 
    
    # 用TreeBuilder解析html
    $tree->parse($resp);
    
    # 輸出文件的名稱用文章標題命名
    if($resp =~ /<meta property="og:title" content="(.*)">/){
        $filename_by_title = "$1";
    }else{
        $filename_by_title = "[公告]";
    }
    say "$filename_by_title";
    #$filename_by_title = "[資訊] 2019年4月新番台灣觀賞管道節目表(4/2)";
    #open(FILE_TEXT,">copy_art/$filename_by_title.txt")||die "$!";
    open(FILE_TEXT,">copy_art/$filename_by_title.txt")||
    open(FILE_TEXT,">>copy_art/dump.txt");
    say FILE_TEXT "目前網址：","$LINE";
    
    # 用tree尋找並存取文章的標題、作者名、發送時間
    foreach my $title ($tree->look_down(class => 'article-metaline',)) {
        say FILE_TEXT $title->as_trimmed_text();
    }
    
    # 將內文依換行符號切割準備逐行分析
    my @values = split('\n', $resp);  
        
    my $print_content = 0;
    # 因為在括弧之外所以內文無法用tree分析，用正則判別式抓取
    foreach my $val (@values) {  
        if($print_content eq 1){
            if($val =~ /<span/){
                $print_content = 0;
            }
            #else{say FILE_TEXT $val;}
            elsif($val =~/<div class="richcontent"/|| $val=~/<a href/){
            }else{
                say FILE_TEXT $val;
            }
        }
        if($val =~ /main-content/){
            $print_content = 1;  
        }
    }  
    
    # 擷取推文
    foreach my $anchor ($tree->look_down(class => 'push',)) {
        my $temp = $anchor->as_trimmed_text();
        say FILE_TEXT $temp;
    }
    close(FILE_TEXT);
    $num = $num + 1;
    #last;
}

close(FILE_TITLE);

