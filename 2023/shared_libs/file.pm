#!/usr/bin/perl
use strict;
use warnings;

package shared_libs::file;

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw(
	get_file_content
);

sub get_file_content {
	my $file_location = shift;

	if ( ! -f $file_location ) {
		die "Missing file $file_location";
	}

	open my $FH, '<', $file_location or 
		die "Unable to open file $file_location for reading";

	my @file_content = qw();
	while ( my $line = <$FH> ) {
		chomp $line;
		push @file_content, $line;
	}

	return \@file_content;
}

1;
