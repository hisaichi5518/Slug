use strict;
use warnings;
use Test::More;

package TriggerTest;
use Slug::Trigger;
my $trigger = Slug::Trigger->new;
$trigger->add_trigger( trigger_test1 => sub {
    my ($self, $t) = @_;
    $t->{test} = "ok";
});

for my $i (0 .. 50) {
    $trigger->add_trigger( trigger_test2 => sub {
        my ($self, $t) = @_;
        push @{$t->{tests}}, $i;
    });
}

sub new { bless {}, shift }
sub trigger { $trigger }

package main;
my $t = TriggerTest->new;
$t->trigger->call_trigger(trigger_test1 => $t);
is $t->{test}, "ok";

$t->trigger->call_trigger(trigger_test2 => $t);
for my $i (0 .. 50) {
    is $t->{tests}->[$i], $i;
}


done_testing;
