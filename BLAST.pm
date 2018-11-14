package BLAST;
use Moose;
use feature 'say';

# Object-oriented programming
# Create a module a parse a BLAST input file

# method to print all the object's attributes in a tab-separated format
sub print_all {
	my ($self) = @_;

	# Check if object has defined transcript value first.

	my $result = join( "\t",
		$self->transcript(), $self->isoform(),  $self->gi(),
		$self->sp(),         $self->prot(),     $self->pident(),
		$self->len(),        $self->mismatch(), $self->gapopen() );

	say $result;

}

# method to accept a single line of BLAST input, parses it, and sets the attributes
sub parse_blast_hit {
	my ( $self, $record ) = @_;

	# Regex to get all attributes via named captures.
	my $parsing_regex = qr/
			(?<transcript>.*?)\|
		    (?<isoform>.*?)\s+
		    gi\|(?<gi>\d+?)\| 
            sp\|(?<sp>.*?)\|
            (?<prot>.*?)\s+  
            (?<pident>\d+?\.\d+?)\s+  
            (?<len>\d+?)\s+ 
		    (?<mismatch>\d+)\s+
		    (?<gapopen>\d+)\s+ 
		/msx;

	# If record can be parsed, set attributes. Otherwise, do nothing.
	if ( $record =~ /$parsing_regex/ ) {
		$self->transcript( $+{transcript} );
		$self->isoform( $+{isoform} );
		$self->gi( $+{gi} );
		$self->sp( $+{sp} );
		$self->prot( $+{prot} );
		$self->pident( $+{pident} );
		$self->len( $+{len} );
		$self->mismatch( $+{mismatch} );
		$self->gapopen( $+{gapopen} );
	}
}

has 'transcript' => (
	is  => 'rw',
	isa => 'Str'
);

has 'isoform' => (
	is  => 'rw',
	isa => 'Str'
);

has 'gi' => (
	is  => 'rw',
	isa => 'Int'
);

has 'sp' => (
	is  => 'rw',
	isa => 'Str'
);

has 'prot' => (
	is  => 'rw',
	isa => 'Str'
);

has 'pident' => (
	is  => 'rw',
	isa => 'Num'
);

has 'len' => (
	is  => 'rw',
	isa => 'Int'
);

has 'mismatch' => (
	is  => 'rw',
	isa => 'Int'
);

has 'gapopen' => (
	is  => 'rw',
	isa => 'Int'
);

1;
