use strict;
use warnings;
use Test::More;
use Slug::Request;

my @tests = (
    {
        host => "localhost",
        path => "hoge",
        uri  => "http://localhost/hoge",
    },
    {
        host => "localhost",
        script_name => "/hoge",
        path => "/huga",
        uri  => "http://localhost/hoge/huga",
    },
    {
        host => "localhost",
        path => "hoge",
        args => [qw/huga 1/],
        uri  => "http://localhost/hoge?huga=1",
    }
);


for my $t (@tests) {
    my $env = {
        HTTP_HOST   => $t->{host}   || undef,
        SCRIPT_NAME => $t->{script_name} || '',
    };
    my $req = Slug::Request->new($env);
    is $req->uri_for($t->{path}, $t->{args}), $t->{uri};
}

done_testing;
