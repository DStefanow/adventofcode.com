#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use lib '..';
use shared_libs::file;

my $file;

GetOptions(
	'file|f=s' => \$file,
);

if ( !defined($file) || $file eq '' ) {
	pod2usage("Usage:\n $0 --file <file>\n");
	die;
}

# Get file content
my $file_content = get_file_content($file);

my ( $game_id, $winning_nums_line, $our_nums_line, @winning_nums, @our_nums, $line_winning_counter );

my $total_points = 0;

foreach my $line (@$file_content) {
	$line_winning_counter = 0; # Reset the winning counter for every line
	$line =~ s/Card (\d+):\s*//g; # Remove metadata
	$game_id = $1;

	# Extract winning and our numbers
	( $winning_nums_line, $our_nums_line ) = split(/\s*\|\s*/, $line);
	
	@winning_nums = split(/\s+/, $winning_nums_line);
	@our_nums = split(/\s+/, $our_nums_line);

	# For every winning number check do we have it in our numbers
	foreach my $winning_num (@winning_nums) {
		if ( grep(/^${winning_num}$/, @our_nums) ) { # We have a winning number, increment the counter
			if ( $line_winning_counter == 0 ) { # Initialise first point
				$line_winning_counter = 1;	
			} else { # Double up the point for every next match
				$line_winning_counter *= 2;
			}
		}
	}

	# Print current line score and add it to the total
	print "Line points for #${game_id}: $line_winning_counter\n";
	$total_points += $line_winning_counter;
}

print "TOTAL POINTS: $total_points\n";

exit 0;
