use strict;
use warnings;
use Test::More;

package AccessorBase;
sub new {
    bless {}, shift;
}

package AccessorTest1;
use base "AccessorBase";
use Slug::Util::Accessor {
    huga => "huga",
    hoge => sub { "hoge" }
};

package AccessorTest2;
use base "AccessorBase";
use Slug::Util::Accessor {
    num => 0,
    str => "",
};

package main;
my $num = [];
for my $i (1 .. 50) {
    $num->[$i] = AccessorTest1->new;

    # huga
    is $num->[$i]->huga, "huga";
    $num->[$i]->huga($i);
    is $num->[$i]->huga, $i;

    # hoge
    is $num->[$i]->hoge, "hoge";
    $num->[$i]->hoge($i);
    is $num->[$i]->hoge, $i;
}
for my $i (51 .. 100) {
    $num->[$i] = AccessorTest2->new;

    # num
    is $num->[$i]->num, 0;
    $num->[$i]->num($i);
    is $num->[$i]->num, $i;

    # str
    is $num->[$i]->str, "";
    $num->[$i]->str($i);
    is $num->[$i]->str, $i;
}

done_testing;
