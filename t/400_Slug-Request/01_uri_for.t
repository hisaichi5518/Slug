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
        script_name => "/",
        path => "/",
        uri  => "http://localhost/",
    },
    {
        host => "localhost",
        path => "hoge",
        args => [name => "hisaichi5518"],
        uri  => "http://localhost/hoge?name=hisaichi5518",
    },
    {
        host => "moe-project.com",
        args => [name => "hisaichi5518", name => "kuso"],
        uri  => "http://moe-project.com/?name=hisaichi5518&name=kuso",
    },
    {
        host => "moe-project.com",
        args => [name => [qw/ hisaichi5518 kuso /]],
        uri  => "http://moe-project.com/?name=hisaichi5518&name=kuso",
    },
);


for my $t (@tests) {
    my $env = {
        HTTP_HOST   => $t->{host}        || undef,
        SCRIPT_NAME => $t->{script_name} || '',
    };
    my $req = Slug::Request->new($env);
    is $req->uri_for($t->{path}, $t->{args}), $t->{uri};
}

done_testing;
