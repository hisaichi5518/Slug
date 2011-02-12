package Slug::Trigger;
use strict;
use warnings;

sub new {
    bless {
        _trigger => {},
    }, shift;
}
sub add_trigger {
    my ($self, %args) = @_;
    while (my ($name, $code) = each %args) {
        $self->{_trigger}->{$name} = []
            unless exists $self->{_trigger}->{$name};
        push @{$self->{_trigger}->{$name}}, $code;
    }
}
sub call_trigger {
    my ($self, $name, @args) = @_;
    my @code = $self->get_trigger_code($name);
    for my $code (@code) {
        $code->($self, @args);
    }
}
sub get_trigger_code {
    my ($self, $name) = @_;
    $self->{_trigger}->{$name} = []
        unless exists $self->{_trigger}->{$name};
    @{$self->{_trigger}->{$name}};
}
1;
__END__

=encoding utf8

=head1 NAME

Slug::Trigger - とりがー！

=head1 SYNOPSIS

  use Slug::Trigger;
  my $trigger = Slug::Trigger->new;
  $trigger->add_trigger("test_trigger" => sub { ... });
  $trigger->call_trigger("test_trigger" => @args);

=head1 DESCRIPTION

とりがー。Plack::Middleware::Hogeがあるから必要ないかなー

=head1 METHOD

=head2 new

=head2 add_trigger

=head2 call_trigger

=head2 get_trigger_code

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
