use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";

BEGIN { use_ok 'MyApp::Web' }

done_testing;
