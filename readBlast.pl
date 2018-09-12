#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

# Open Blast file and store transcript ID as keys, SwissProt ID as values in a hash

my %transcript_to_protein;
my $ID;
my $Swiss;

open( my $BLAST, '<', 'blastp.outfmt6' ) or die $!;

while (my $row = <$BLAST>) {
	chomp $row;

	if($row =~ /(c\S*\|)/ ) {    
	$ID = $1;
	$ID =~ s/\|//;   
	}
	
	if ($row =~ /(sp\|\S*\|)/ ) {
	$Swiss = $1;
	$Swiss =~ s/sp\|//;
	$Swiss =~ s/\|//;
	}
	
	$transcript_to_protein{$ID} = $Swiss;
}

print Dumper(\%transcript_to_protein);
