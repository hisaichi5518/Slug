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
);

for my $t (@tests) {
    my $env = {
        HTTP_HOST   => $t->{host}        || undef,
        SCRIPT_NAME => $t->{script_name} || '',
    };
    my $req = Slug::Request->new($env);
    is $req->uri_with($t->{args}), $t->{uri};
}

done_testing;
