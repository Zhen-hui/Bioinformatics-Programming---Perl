#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

my %gene_to_GO;
my $ObjectID;
my $GOID;

read_gene_to_GO();

## Load protein IDs and corresponding GO terms to hash for lookup.
sub read_gene_to_GO {
	
	# Read in the GO annotation file
	open( GENE_TO_GO, '<', 'gene_association_subset.txt' ) or die $!;
	
	# store the object ID (2nd column) and GO ID (5th column)
	while (<GENE_TO_GO>) {
		chomp;
	    my (@temp_data) = split( /\t/ );
	    $ObjectID = $temp_data[1];
	    $GOID = $temp_data[4];
	    $gene_to_GO{$ObjectID} = $GOID;
	}	 	
}

print Dumper(\%gene_to_GO);


