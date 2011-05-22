use strict;
use warnings;

use Test::More;
{
    package AccessorTest;
    use Slug::Util::Accessor {
        str => "string",
        num => 25,
        lazy   => sub { 5 * 20 },
        no_str => "",
        no_num => 0,
    };
    sub new {
        my $class = shift;
        bless {@_}, $class;
    }
}

my $t = AccessorTest->new;
is $t->str, "string";
is $t->num, 25;
is $t->lazy, 100;
ok !$t->no_str;
ok !$t->no_num;

$t->str("String: hisaichi5518");
$t->num(123456789012345678901);
$t->lazy(sub { 1 + 1 });
$t->no_str("str");
$t->no_num(1234);
is $t->str, "String: hisaichi5518";
is $t->num, 123456789012345678901;
is_deeply $t->lazy->(), 2;
is $t->no_str, "str";
is $t->no_num, 1234;

for my $i (1..50) {
    $t->num($i);
    is $t->num, $i;
}

$t = AccessorTest->new(str => "STRING!", num => 1);
is $t->str, "STRING!";
is $t->num, 1;

done_testing;
