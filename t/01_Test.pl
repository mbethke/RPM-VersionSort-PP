use strict;
use warnings;
use Test::More;

use_ok 'RPM::VersionSort::PP';
is( rpmvercmp("1.0", "2.0"), -1 );
is( rpmvercmp("2.0", "1.0"), 1 );
is( rpmvercmp("2.0", "2.0"), 0 );
is( rpmvercmp("1.6.6-1_SL", "1.6.3p6-0.6x"), 1);
is( rpmvercmp("1.3.26_2.8.10_1.27-5", "1.3.19_2.8.1_1.25-3"), 1 );

done_testing;
