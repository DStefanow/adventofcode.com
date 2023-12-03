#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;
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

my @input_matrix = qw();
my $matrix_row = 0;

# Create and populate the input matrix
foreach my $file_line ( @$file_content ) {
	my @line_chars = split('', $file_line);
	$input_matrix[$matrix_row] = \@line_chars;
	$matrix_row++;
}


# Set the number of rows and columns they are the same
my $row_count = @input_matrix;
my $col_count = $row_count;

# Helper variables
my ( $element, $start_index, $end_index, @element_digits, $number );

my $is_part_of_num = 0;
my $element_sum = 0; # Variable to store the result sum

# Traverse the 2D dimensional array for calculation
for (my $row = 0; $row < $row_count; $row++) {
	for (my $col = 0; $col < $col_count; $col++) {
		$element = $input_matrix[$row][$col];

		if ( $element =~ /\d/ && !$is_part_of_num ) { # First occurance of number proceed to the next
			$start_index = $col;
			$end_index = $col;
			push @element_digits, $element;
			$is_part_of_num = 1;

			if ( $col == $col_count - 1 ) {
				$number = join('', @element_digits);
				proceed_number($number, $row, $start_index, $end_index);
				@element_digits = qw();
				$is_part_of_num = 0;
			}

			next;
		} elsif ( $element =~ /\d/ && $is_part_of_num ) { # Get a part of number and proceed it
			$end_index = $col;
			push @element_digits, $element;

			if ( $col == $col_count - 1 ) {
				$number = join('', @element_digits);
				proceed_number($number, $row, $start_index, $end_index);

				@element_digits = qw();
				$is_part_of_num = 0;
			}

			next;
		} else { # Not a digit element - check if we have a number for proceed
			if ( $is_part_of_num ) {
				$number = join('', @element_digits);
				proceed_number($number, $row, $start_index, $end_index);

				@element_digits = qw();
			}

			$is_part_of_num = 0; # Reset the number
		}
	}
}


sub proceed_number {
	my ( $number, $row, $start_index, $end_index ) = @_;

	# Check if we have a "special" symbol around the number (where 'd' stands for the number)
	# x ... x
	# x  n  x
	# x ... x
	
	# Check upper row
	if ( $row > 0) {
		for ( my $upper_start = $start_index - 1; $upper_start <= $end_index + 1; $upper_start++ ) {
			if ( $upper_start == $col_count ) {
				last;
			}

			if ( $upper_start < 0 ) {
				next;
			}
	
			if ( $input_matrix[$row - 1][$upper_start] !~ /\d|\./) {
				print "We have upper match for $number!\n";
				$element_sum += $number;
				last;
			}
		}
	}

	# Check left element
	if ( $start_index - 1 >= 0 ) {
		if ( $input_matrix[$row][$start_index - 1] !~ /\d|\./ ) {
			print "We have left match for $number!\n";
			$element_sum += $number;
		}
	}

	# Check right element
	if ( $end_index + 1 < $col_count ) {
		if ( $input_matrix[$row][$end_index + 1] !~ /\d|\./ ) {
			print "We have right match for $number!\n";
			$element_sum += $number;
		}
	}

	# Check bottom row
	if ( $row + 1 < $row_count ) {
		for ( my $upper_start = $start_index - 1; $upper_start <= $end_index + 1; $upper_start++ ) {
			if ( $upper_start == $col_count ) {
				last;
			}

			if ( $upper_start < 0 ) {
				next;
			}
	
			if ( $input_matrix[$row + 1][$upper_start] !~ /\d|\./) {
				print "We have bottom match for $number!\n";
				$element_sum += $number;
				last;
			}
		}
	}

	#print "Element: $number on row: $row with start: $start_index and end: $end_index\n";
}

print "TOTAL SUM: $element_sum\n";

exit 0;
