use strict;
use warnings;
use Test::More;

BEGIN {
    map { use_ok $_ } qw/
        Slug::Util::Accessor
        Slug::Plugins
        Slug::Plugin::ConfigLoader
        Slug::Plugin::Web::View::Xslate
        Slug::Request
        Slug::Response
        Slug
    /;
}

done_testing;
