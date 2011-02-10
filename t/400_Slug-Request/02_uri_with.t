use strict;
use warnings;
use Test::More;
use Slug::Request;

my @tests = (
    {
        host => "localhost",
        args => [qw/huga 1/],
        uri  => "http://localhost/?huga=1",
    }
);


for my $t (@tests) {
    my $env = {
        HTTP_HOST   => $t->{host}   || undef,
        SCRIPT_NAME => $t->{script_name} || '',
    };
    my $req = Slug::Request->new($env);
    is $req->uri_with($t->{args}), $t->{uri};
}

done_testing;
