package Slug::Trigger;
use strict;
use warnings;
use Slug;

sub new { bless {}, shift }
sub add_trigger {
    my $self = shift;
    Slug::_deprecated("trigger->add_trigger" => '$c->plugins->add_hook');
    Slug->context->plugins->add_hook(@_);
}
sub call_trigger {
    my $self = shift;
    Slug::_deprecated("trigger->call_trigger" => '$c->plugins->run_hook');
    Slug->context->plugins->run_hook(@_);
}
sub get_trigger_code {
    my $self = shift;
    Slug::_deprecated("trigger->get_trigger_code" => '$c->plugins->get_hook_codes');
    Slug->context->plugins->get_hook_codes(@_);
}
1;
__END__
