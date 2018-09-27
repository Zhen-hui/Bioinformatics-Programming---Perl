#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

# Open Blast file and store transcript ID as keys, SwissProt ID as values in a hash

my %transcript_to_protein;
my $ID;
my $Swiss;

# Open a file handler to read from the Blast file
open( my $BLAST, '<', 'blastp.outfmt6' ) or die $!;

# Use regular expression to find the values desired
while (my $row = <$BLAST>) {

	chomp $row;

	if($row =~ /(c\S+?)\|/m ) {    
	$ID = $1;
	}
	
	if ($row =~ /sp\|(\S*)\|/m ) {
	$Swiss = $1;
	}
	
	$transcript_to_protein{$ID} = $Swiss;
}

print Dumper(\%transcript_to_protein);
