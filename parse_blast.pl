#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

read_BLAST();

sub read_BLAST {
	my $BLAST_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST, '<', $BLAST_file ) or die $!;

	# Open a file handlers to store output
	open( OUT,    '>', "parsed_BLAST_output.txt" )     or die $!;
	open( STDERR, '>', "not_parsed_BLAST_output.txt" ) or die $!;

	# Read file and parse for data of interest.
	while ( my $line = <BLAST> ) {
		chomp $line;
		
		my $parsing_regex = qr/
			^(?<transcript>\S+?)\|
		    (?<isoform>\w+\.+[1-9]+)?\t
		    gi\|(?<gi>\d+?)\| 
            sp\|(?<sp>.*?)\|
            (?<prot>.*_SCHPO)\s  
            (?<pident>\d+\.\d+)\s  
            (?<length>\d+)\s 
		    (?<mismatch>\d+)\s
		    (?<gapopen>\d+)\s 
		/msx;

		if ( $line =~ /$parsing_regex/ ) {
			say OUT join( "\t", $+{transcript}, $+{isoform}, $+{gi}, $+{sp}, $+{prot}, $+{pident}, $+{length}, $+{mismatch}, $+{gapopen} );
		} 
		else {
			say STDERR $line;
		}
	}
}