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

# Parse the input data for times and distances
my $time_str = @{$file_content}[0];
$time_str =~ s/Time:\s+//g;

my @times = split(/\s+/, $time_str);

my $distance_str = @{$file_content}[1];
$distance_str =~ s/Distance:\s+//g;

my @distances = split(/\s+/, $distance_str);

my $final_margin = 1; # For the final result

# Helper variables
my ( $current_combinations, $time_to_travel, $current_distance );

# Traverse all times in the array
for ( my $index = 0; $index < @times; $index++ ){
	print "Time: $times[$index] and distance: $distances[$index]\n";

	$current_combinations = 0; # Hold the current combinations for the single track

	# Try all combinations from the race to find the valid combinations for win
	for ( my $current_speed = 1; $current_speed < $distances[$index]; $current_speed++ ) {
		# Set the time to travel with extracting current speed from the time
		# For every 1 meter faster we have 1 second less for competing
		$time_to_travel = $times[$index] - $current_speed;

		# Calculate the current distance with a simple s = v * t function
		$current_distance = $current_speed * $time_to_travel;

		# Check if the current distance is better than the record and increment current combinations
		if ($current_distance > $distances[$index] ) {
			$current_combinations++;
		}
	}

	# Multiple current combinations to the margin
	$final_margin *= $current_combinations;
}

print "Final margin: $final_margin\n";

exit 0;
