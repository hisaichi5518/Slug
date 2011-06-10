package Slug::Plugins;

use strict;
use warnings;

use Plack::Util ();
use Slug;

sub new {
    bless +{hooks => {}}, shift;
}
sub hooks { shift->{hooks} }
sub init_hook {
    my ($self, $name) = @_;
    $self->hooks->{$name} = [];
}
sub add_hook {
    my ($self, %args) = @_;
    while (my ($name, $code) = each %args) {

        # _deprecated の為にやる
        Slug::_deprecated("html_filter" => "after_dispatch") if $name eq "html_filter";

        $self->init_hook($name)
            unless exists $self->hooks->{$name};

        $code = ref $code eq "ARRAY" ? $code : [$code];
        for my $c (@$code) {
            push @{$self->hooks->{$name}}, $c;
        }
    }
}
sub run_hook {
    my ($self, $name, $c, $data, @args) = @_;
    my @code = $self->get_hook_codes($name);
    for my $code (@code) {
        $data = $code->($c, $data, @args);
    }
    $data;
}
sub get_hook_codes {
    my ($self, $name) = @_;
    $self->init_hook($name)
        unless exists $self->hooks->{$name};
    @{$self->hooks->{$name}};
}
sub before_dispatch {
    shift->run_hook('before_dispatch', @_);
}
sub after_dispatch {
    shift->run_hook('after_dispatch', @_);
}
sub template_path {
    shift->run_hook('template_path', @_);
}
sub html_filter {
    Slug::_deprecated("html_filter" => "after_dispatch");
    shift->run_hook('html_filter', @_);
}
sub init_plugin {
    my ($self, $name, $c, $conf) = @_;
    Plack::Util::load_class($name, 'Slug::Plugin')->init($c, $conf);
}

1;
__END__

=pod

=encoding=utf8

=head1 METHOD

=head2 new

=head2 hooks

=head2 init_hook

=head2 add_hook

=head2 run_hook

=head2 get_hook_codes

=head2 before_dispatch

=head2 after_dispatch

=head2 template_path

=head2 html_filter

=head2 init_plugin

=cut
