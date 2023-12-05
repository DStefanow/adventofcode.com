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

my ( $game_id, $winning_nums_line, $our_nums_line, @winning_nums, @our_nums, $line_winning_counter, $new_index );

# Contains occurances for every ticket
# {
#	1 => 1,
#	2 => 2,
#	3 => 4,
#	4 => 8,
#	5 => 14,
#	6 => 1,
# }
#
# In the end we have a total counter of 30 (sums of all values above)
my $tickets_counter = {};

foreach my $line (@$file_content) {
	$line_winning_counter = 0; # Reset the winning counter for every line

	$line =~ s/Card\s+(\d+):\s+//g; # Remove metadata
	$game_id = $1;

	# Set the initial value for the current game or increment it if we have a match
	if ( !defined($tickets_counter->{$game_id}) ) {
		$tickets_counter->{$game_id} = 1;
	} else {
		$tickets_counter->{$game_id} += 1;
	}

	# Extract winning and our numbers
	( $winning_nums_line, $our_nums_line ) = split(/\s*\|\s*/, $line);
	
	@winning_nums = split(/\s+/, $winning_nums_line);
	@our_nums = split(/\s+/, $our_nums_line);

	foreach my $iteration (1..$tickets_counter->{$game_id}) {
		# For every winning number check do we have it in our numbers
		foreach my $winning_num (@winning_nums) {
			if ( grep(/^${winning_num}$/, @our_nums) ) { # We have a winning number, increment the counter
				$line_winning_counter++;
				$new_index = $game_id + $line_winning_counter;
		
				# Set the initial value for a game or increment it if we have a match
				if ( !defined($tickets_counter->{$new_index}) ) {
					$tickets_counter->{$new_index} = 1;
				} else {
					$tickets_counter->{$new_index} += 1;
				}
			}
		}

		# Reset the winning counter for every line
		$line_winning_counter = 0; 
	}
}

my $total_points = 0; # Final result answer
foreach my $value ( values %{$tickets_counter} ) {
	$total_points += $value;
}

use Data::Dumper;
print Dumper(\$tickets_counter);
print "TOTAL POINTS: $total_points\n";

exit 0;
