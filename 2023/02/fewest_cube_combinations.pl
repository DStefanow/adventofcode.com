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

# Helper variables
my ( @withdraws, @cubes, @cubes_combinations, $power_of_withdraw, $fewest_current_withdraw );

# Result value
my $result_sum = 0;

# Traverse every line of 
foreach my $line (@{$file_content}) {
	# Reset the counter of every withdraw color
	$fewest_current_withdraw = {
		red => 0,
		green => 0,
		blue => 0,
	};

	# Remove the meta data from the input line
	$line =~ s/^Game \d+:\s+//g;

	# Get all withdraws from every game
	@withdraws = split(/\s*\;\s*/, $line);

	foreach my $withdraw (@withdraws) {
		# From every withdraw get the cubes combinations
		@cubes_combinations = split(/\s*\,\s*/, $withdraw);

		# Get every cube combination
		foreach my $cubes (@cubes_combinations) {
			my ( $cube_count, $color ) = split(/\s+/, $cubes);

			# Compare current value and set it if it's bigger than the current max
			if ( $cube_count > $fewest_current_withdraw->{$color}) {
				$fewest_current_withdraw->{$color} = $cube_count;
			}
		}

		# Calculate the power of withdraw max
		$power_of_withdraw = $fewest_current_withdraw->{red} * $fewest_current_withdraw->{green} * $fewest_current_withdraw->{blue};
	}

	$result_sum += $power_of_withdraw;
}

print "FINAL RESULT: $result_sum\n";

exit 0;
