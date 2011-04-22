use strict;
use warnings;
use Test::More;
use Slug::Request;

my @tests = (
    {
        host => "localhost",
        args => [name => "hisaichi5518"],
        uri  => "http://localhost/?name=hisaichi5518",
    },
    {
        host => "moe-project.com",
        args => [name => "hisaichi5518"],
        uri  => "http://moe-project.com/?name=hisaichi5518",
    },
    {
        host => "moe-project.com",
        args => [name => "hisaichi5518", name => "kuso"],
        uri  => "http://moe-project.com/?name=hisaichi5518&name=kuso",
    },
    {
        host => "moe-project.com",
        args => [name => ["hisaichi5518", "kuso"]],
        uri  => "http://moe-project.com/?name=hisaichi5518&name=kuso",
    },
    {
        host => "localhost",
        args => [name => "hisaichi5518"],
        script_name => "/index.cgi",
        path_info => "/hoge",
        uri => "http://localhost/index.cgi/hoge?name=hisaichi5518",
    },
    {
        host => "localhost",
        args => [name => "hoge"],
        script_name => "/index.cgi",
        uri => "http://localhost/index.cgi?name=hoge",
    }
);

for my $t (@tests) {
    my $env = {
        HTTP_HOST   => $t->{host}        || undef,
        SCRIPT_NAME => $t->{script_name} || '',
        PATH_INFO   => $t->{path_info}   || '',
    };
    my $req = Slug::Request->new($env);
    is $req->uri_with($t->{args}), $t->{uri};
}

done_testing;
