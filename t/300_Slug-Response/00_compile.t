use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Slug::Response' }

ok(Slug::Response->new(200));

done_testing;
