#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my $file;

my $num_map = {
	1 => 1,
	2 => 2,
	3 => 3,
	4 => 4,
	5 => 5,
	6 => 6,
	7 => 7,
	8 => 8,
	9 => 9,
	0 => 0,
	one => 1,
	two => 2,
	three => 3,
	four => 4,
	five => 5,
	six => 6,
	seven => 7,
	eight => 8,
	nine => 9,
	zero => 0,
};

my $nums = join('|', keys %$num_map);

GetOptions(
	'file|f=s' => \$file,
);

if ( !defined($file) ) {
	pod2usage("Usage:\n$0 --file <file>\n");
	exit 2;
}

if ( ! -f $file ) {
	print "Missing file: $file\n";
	exit 2;
}

open my $FH, '<', $file or die("Unable to open $file for reading.\n");

my ($first, $last);

my $sum = 0;

while ( my $line = <$FH> ) {
	chomp $line;
	
	$line =~ /^(.*?)($nums)/;
	$first = $2;

	$line =~ /.*($nums)/;
	$last = $1;

	$sum += int($num_map->{$first}. $num_map->{$last});
}

print "Total: $sum\n";

exit 0;
