#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# This program parses the Gene Ontology file with regular expression to extract:
# 1. id
# 2. name
# 3. namespace
# 4. def
# 5. multiple alt_id entries
# 6. multiple is_a entries

# Call the subroutine
read_GO_desc();

# Create a subroutine
sub read_GO_desc {

	# Open a filehandler for reading
	my $GO_desc_file = '../Module01/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;
	
	# Open a file handlers to store outputs
	open( OUT, '>', "parsed_output.txt" ) or die $!;
	open( STDERR, '>', "not_parsed_output.txt" ) or die $!;
	
	# Initialize $_ so redefinition of $/ to regex will not cause warning.
	$_ = '';
	local $/ = /\[Term]|\[Typedef]/;

	# Read file and parse for data of interest.
	while (my $long_GO_desc = <GO_DESC>) {
		chomp $long_GO_desc;
		
		my $parsing_regex = qr/
			^id:\s+(?<id>GO:[0-9]+)\n
			^name:\s+(?<name>.*?)\n 
			^namespace:\s+(?<namespace>\S+)\n 
			^def:\s+"(?<def>.+?)"                
		/msx;						
		                                   
		# Regex to get all is_a Go Terms
		my $findIsa = qr/
			^is_a:\s+(?<isa>.*?)\s+!
		/msx;
		
		# Regex to get all alt_id Go Terms
		my $findAltId = qr/
			^alt_id:\s+(?<alt_id>.*?)\s+
		/msx;

		# Print each iteration have all matching information, print result to output file
		if ( $long_GO_desc =~ /$parsing_regex/ ) {
			say OUT join ("\n", $+{id}, $+{name}, $+{namespace}, $+{def});			
			
			say OUT "alt_ids:";
			my @alt_ids = ();
			while ( $long_GO_desc =~ /$findAltId/g ) {
				push( @alt_ids, $+{alt_id} );
			}
			
			# Not all records contain alt IDs, so check first before printing.
			if ( @alt_ids ) {
				say OUT join( ",", @alt_ids );
			}
			
			say OUT "isa:";
			my @isas = ();
			while ( $long_GO_desc =~ /$findIsa/g ) {
				push( @isas, $+{isa} );
			}
			say OUT join( ",", @isas ), "\n";
		}
		else {
			say STDERR $long_GO_desc;
		}
	}
}
