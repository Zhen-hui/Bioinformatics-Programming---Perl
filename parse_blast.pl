#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use BLAST;

#  Uses the BLAST class to create BLAST objects
my $BLAST_hit = read_BLAST();
foreach my $transcript ( sort keys $BLAST_hit ) {
	$BLAST_hit->{$transcript}->print_all();
}

# Return hash of BLASH hits
sub read_BLAST {
	my $BLAST_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST_fh, '<', $BLAST_file ) or die $!;

	# Hash to store BLAST hits
	my %BLAST_hit;

	# Read file and parse for data of interest.
	while ( my $record = <BLAST_fh> ) {
		chomp $record;

		# Instantiate new BLAST hit with new() constructor
		my $hit = BLAST->new();
		
		# Invoke object's method, parse_blast_hit, to set attributes
		$hit->parse_blast_hit($record);

		# Object must have defined 'id' attribute to be added to hash
		if ( defined $hit->transcript() ) {
			$BLAST_hit{ $hit->transcript() } = $hit;
		}
	}
	close BLAST_fh;
	return \%BLAST_hit;
}
