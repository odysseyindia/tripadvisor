#!/usr/bin/env perl

use 5.010;
use strict;
use utf8;
use warnings;

use Mojo::UserAgent;
use Mojo::DOM;
 
my $url = 'https://www.tripadvisor.com/VacationRentalReview-g469404-d5892828-Villa_Anggrek_66_Seminyak_66_Beach-Seminyak_Kuta_District_Bali.htm';

# read the data
my $ua  = Mojo::UserAgent->new;
my $dom = $ua->get($url => {Accept => 'text/plain'})->res->dom;

# find the total number of reviews
my $rating_summary_count = $dom->find('a.rating-summary-count')->first->all_text;
   $rating_summary_count =~ s/\r|\n//g;

# find the overal rating
my  $rating_summary = 0 ;

for  ( map {$_->attr('content')} $dom->find('div.rating-summary-bubbles')->each() ) {
   $rating_summary = $_;
}

# the review description in English
my $language = $dom->find('span.rating-in-language')->first->all_text;

say 'status = '.$language.' ' .$rating_summary.' with '.$rating_summary_count;

# loop through the individual reviews
for my $e ( $dom->find('div.reviewSelector')->each) {

  my $review_id = $e->{id};

  my $quote = $e->find('div.quote')->first->all_text;
     $quote =~ s/\r|\n//g;         # remove carriage return     
     $quote = substr($quote,1,-1); # remove quotes
 
  my $rating = 0;

  for ($e->find('span.bubble_50')->each) {
     $rating = 50;
  }

  my $entry  = $e->find('div.entry :nth-child(1)')->first->all_text;
     $entry  =~ s/\r|\n//g; 

  my $datestr = $e->find('span.ratingDate')->first->all_text;
  my ($date,$stay) = split(/\n/,$datestr);
      chomp($date);
      $date =~s/Reviewed //g;
      $stay =~s/for a stay in //g;

   say 'review = '.$review_id;
   say 'quote  = '.$quote;
   say 'rating = '.$rating;
   say 'date   = '.$date;
   say 'stay   = '.$stay;
   say 'entry  = '.$entry . "\n";

}

