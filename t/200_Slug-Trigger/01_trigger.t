use strict;
use warnings;
use Test::More;
{
    package TriggerTest;
    use Slug::Trigger;
    my $trigger = Slug::Trigger->new;
    $trigger->add_trigger( add_hoge => sub {
        my ($self, $t) = @_;
        $t->{hoge} = "ok!";
    });
    for my $i (0 .. 50) {
        $trigger->add_trigger( add_numbers => sub {
            my ($self, $t) = @_;
            push @{$t->{num}}, $i;
        });
    }

    sub new { bless {}, shift }
    sub trigger { $trigger }
}
{
    my $t = TriggerTest->new;
    isa_ok $t->trigger, "Slug::Trigger";
    $t->trigger->call_trigger( add_hoge => $t );
    is $t->{hoge}, "ok!";

    $t->trigger->call_trigger( add_numbers => $t );
    for my $i (0 .. 50) {
        is $t->{num}->[$i], $i;
    }
    my $hoge = [sub{ 'hoge' }, sub{ "hogehoge" }];
    $t->trigger->{_trigger}->{hoge} = $hoge;
    is_deeply [$t->trigger->get_trigger_code('hoge')], $hoge;
}
done_testing;
