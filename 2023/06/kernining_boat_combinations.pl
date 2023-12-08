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

# Parse the input data and remove trailing spaces to create one big number for distance and time
my $time_str = @{$file_content}[0];
$time_str =~ s/Time:\s+//g;

my @times = split(/\s+/, $time_str);
my $race_time = int(join('', @times));

my $distance_str = @{$file_content}[1];
$distance_str =~ s/Distance:\s+//g;

my @distances = split(/\s+/, $distance_str);
my $race_distance = int(join('', @distances));

my ( $current_speed, $total_combinations, $time_to_travel, $current_distance, $first_possible_speed, $last_possible_speed );

# Get first possible speed
for ( $current_speed = 1; $current_speed < $race_distance; $current_speed++ ) {
	$time_to_travel = $race_time - $current_speed;
	$current_distance = $current_speed * $time_to_travel;

	if ($current_distance > $race_distance ) {
		$first_possible_speed = $current_speed;
		last;
	}
}

# Get last possible speed
for ( $current_speed = $race_time; $current_speed > $first_possible_speed; $current_speed-- ) {
	$time_to_travel = $race_time - $current_speed;
	$current_distance = $current_speed * $time_to_travel;

	if ($current_distance > $race_distance ) {
		$last_possible_speed = $current_speed;
		last;
	}
}

# Calculate possible combinations
$total_combinations = $last_possible_speed - $first_possible_speed + 1;

print "RESULT: $total_combinations\n";

exit 0;
