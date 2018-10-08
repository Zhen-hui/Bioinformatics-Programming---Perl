#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use DBI;

# Prompt user input
say "Enter a term ID (press enter to quit): ";
my $ID = <STDIN>;
chomp $ID;

# Continue prompting user input until user wants to quit by pressing "enter"
while ( $ID ne "" ) {

# If user enter whole numbers, connect with MySQL, otherwise reprompt for user input
	if ( $ID =~ m/^\d+$/ ) {

		my ( $dbh, $sth, $id, $name );

		# Establish connection with MySQL in server
		$dbh = DBI->connect( 'dbi:mysql:go', 'trinh.z', 'binf6200' )
		  || die "Error opening database: $DBI::errstr\n";

		# Query id and name from the term table
		$sth = $dbh->prepare("SELECT id, name FROM term WHERE id = $ID;")
		  || die "Prepare failed: $DBI::errstr\n";

		# Exercute the statement handler
		$sth->execute()
		  || die "Couldn't execute query: $DBI::errstr\n";

# If the term id entered is found, return id and name, otherwise print error message
		my $matches = $sth->rows();
		unless ($matches) {
			say "ID ('$ID') not found!\n";
		}
		else {
			# Retrieve all results
			while ( ( $id, $name ) = $sth->fetchrow_array ) {
				say "  ID: $id";
				say "name: $name\n";
			}
		}

		# Close connection with MySQL
		$sth->finish();
		$dbh->disconnect || die "Failed to disconnect\n";
	}

	else {
		say "Enter numbers only!\n";
	}

	# Start another cycle
	say "Enter a term ID (press enter to quit): ";
	$ID = <STDIN>;
	chomp $ID;
}
