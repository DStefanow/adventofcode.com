#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use lib '..';
use shared_libs::file;

my $max_combinations = {
	red => 12,
	green => 13,
	blue => 14,
};

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

# Helper variables
my ( $game_id, @withdraws, @cubes, @cubes_combinations, $is_valid_withdraw );

# Result value
my $result_sum = 0;

# Traverse every line of 
foreach my $line (@{$file_content}) {
	# Set the withdraw to valid in the begining of every game
	$is_valid_withdraw = 1;

	# Remove the meta data and extract the game ID
	$line =~ s/^Game (\d+):\s+//g;
	$game_id = $1;

	# Get all withdraws from every game
	@withdraws = split(/\s*\;\s*/, $line);

	foreach my $withdraw (@withdraws) {
		# From every withdraw get the cubes combinations
		@cubes_combinations = split(/\s*\,\s*/, $withdraw);

		# Get every cube combination
		foreach my $cubes (@cubes_combinations) {
			my ( $cube_count, $color ) = split(/\s+/, $cubes);

			# Check for possible combinations from input criteria
			if ( $cube_count > $max_combinations->{$color} ) {
				$is_valid_withdraw = 0;
				last;
			}
		}

		# Exit also from the main withdraw loop
		if ( !$is_valid_withdraw ) {
			last;
		}
	}

	if ( $is_valid_withdraw ) {
		print "Game $game_id is valid\n";
		$result_sum += $game_id;
	}
}

print "FINAL RESULT: $result_sum\n";

exit 0;
