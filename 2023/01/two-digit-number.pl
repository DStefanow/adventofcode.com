#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my $file;

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
	
	$line =~ /^(.*?)(\d)/;
	$first = $2;

	$line =~ /.*(\d)/;
	$last = $1;

	$sum += int($first . $last);
}

print "Total: $sum\n";

exit 0;
