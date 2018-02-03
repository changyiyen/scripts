#!/usr/bin/perl

# translate.pl - print English Wikipedia link names in Chinese
# usage: perl translate.pl <Wikipedia_page_name>
# Written by Chang-Yi Yen
# Initial version written in November 2015

use strict;
use LWP::Simple;
use URI::Escape;

if (scalar @ARGV < 1) {
  print STDERR "usage: translate.pl <Wikipedia_page_name>";
  print STDERR "example 1: translate.pl Republic_of_China";
  print STDERR "example 2: translate.pl 'Raid on Taipei'";
  exit 1;
}

sub uniq {
  my %items;
  grep !$items{$_}++, @_;
}

for my $url (@ARGV) {
  # Transformations for generating URL
  $url =~ s/ /_/g;

  # Get page contents
  my $page = get("https://en.wikipedia.org/wiki/" . $url);
  # The regex for Wikipedia titles could use more work
  my @terms = ($page =~ /<a href="\/wiki\/([-0-9A-Za-z_#() ]+)"/g);
  
  @terms = uniq(sort(@terms));

  print "## Printing found links: ##";
  for (sort @terms) {
    print $_, "\n";
  }

  # Arbitrary debugging test page
  #@terms = ("Washington_Naval_Treaty");

  print "## Printing Chinese page names: ##";
  for (@terms) {
    my $p = get("https://en.wikipedia.org/wiki/" . $_);
    my @zh_term = ($p =~ /<li class="interlanguage-link interwiki-zh"><a href="https:\/\/zh.wikipedia.org\/wiki\/(.+?)"/);
    my $zh_term = @zh_term ? pop(@zh_term) : "(nil)";
    print "$_ : ", uri_unescape($zh_term), "\n";
  }
}
