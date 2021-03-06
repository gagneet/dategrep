#!/usr/bin/perl

use strict;
use warnings;
use Test::Command::Simple;
use Test::More;
use FindBin qw($Bin);

my @lines;

# empty files
run_ok( './bin/dategrep','--format=%Y',"$Bin/files/empty" );

# files with line before and after date range
run_ok(
    './bin/dategrep',
    '--format=%Y-%m-%d %H:%M',
    '--start=2014-03-23 14:15',
    '--end=2014-03-23 14:17',
    "$Bin/files/test01.log"
);
(@lines) = split( /\n/, stdout() );
chomp(@lines);
is( $lines[0], "2014-03-23 14:15 line 1" );
is( $lines[1], "2014-03-23 14:16 line 1" );

# files with every line in date range
run_ok( './bin/dategrep', '--format=%Y-%m-%d %H:%M', "$Bin/files/test01.log" );
(@lines) = split( /\n/, stdout() );
is( @lines, 4 );

run( './bin/dategrep',"$Bin/files/empty" );
isnt(rc(),0);
chomp(my $error = stderr());
is($error,'dategrep: --format is a required parameter');

$ENV{DATEGREP_DEFAULT_FORMAT} = '%Y-%m-%d %H:%M';
run_ok( './bin/dategrep', "$Bin/files/test01.log" );

run_ok( './bin/dategrep', '--sort-files', "$Bin/files/test01.log", "$Bin/files/test02.log" );
(@lines) = split( /\n/, stdout() );
is( $lines[0], "2014-03-23 13:14 line 1" );

run_ok( './bin/dategrep', "$Bin/files/test01.log", "$Bin/files/test02.log" );
(@lines) = split( /\n/, stdout() );
is( $lines[0], "2014-03-23 14:14 line 1" );


delete $ENV{DATEGREP_DEFAULT_FORMAT};

done_testing();
