#! /usr/bin/perl

use strict;
use warnings;
use Test::More;
use Log::Any '$log';
$SIG{__DIE__}= $SIG{__WARN__}= sub { diag @_; };

use_ok( 'Log::Any::Adapter', 'Daemontools' ) || BAIL_OUT;

my $buf;

sub reset_stderr {
	close STDERR;
	$buf= '';
	open STDERR, '>', \$buf or die "Can't redirect STDERR to a memory buffer: $!";
}

reset_stderr;
$log->warn("test1");
like( $buf, qr/warning: test1\n/ );

reset_stderr;
$log->error("test2");
like( $buf, qr/error: test2\n/ );

reset_stderr;
$log->debug("test3");
is( length $buf, 0 );

Log::Any::Adapter->set('Daemontools', filter => undef);
$log->debug("test4");
like( $buf, qr/debug: test4\n/ );

done_testing;
