package Slug::Request;
use strict;
use warnings;
use parent 'Plack::Request';
use Slug;
use Slug::Response;
use Hash::MultiValue;

sub uri_for {
    my($self, $path, $args) = @_;
    $path ||= "";
    my $uri      = $self->base;
    my $uri_path = $uri->path || "/";

    $uri_path =~ s{([^/])$}{$1/}g;
    $path     =~ s{^/}{}g;

    $uri->path($uri_path . ($path || ""));
    $uri->query_form(@$args) if $args;
    $uri;
}
sub uri_with {
    my($self, $args) = @_;
    my $uri = $self->uri;
    $uri->query_form(@$args) if $args;
    $uri;
}
sub new_response {
    my $self = shift;
    Slug::Response->new(@_);
}
sub args {
    shift->env->{'slug.routing_args'};
}
sub body_parameters {
    my $self = shift;
    $self->env->{'slug.request.body'} ||=
        $self->_decode_parameters(
            $self->SUPER::body_parameters
        );
}
sub query_parameters {
    my $self = shift;
    $self->env->{'slug.request.query'} ||=
        $self->_decode_parameters(
            $self->SUPER::query_parameters
        );
}
sub _decode_parameters {
    my ($self, $parameters) = @_;
    my $encoding = Slug->context->encoding;
    my @flatten = $parameters->flatten;
    my @decoded;
    for my $v (@flatten) {
        push @decoded, $encoding->decode($v),
    }
    return Hash::MultiValue->new(@decoded);
}
sub parameters {
    my $self = shift;
    $self->env->{'slug.request.merged'} ||= do {
        my $q = $self->query_parameters;
        my $b = $self->body_parameters;
        Hash::MultiValue->new(
            $q->flatten,
            $b->flatten,
        );
    };
}
sub body_parameters_raw {
    shift->SUPER::body_parameters(@_);
}
sub query_parameters_raw {
    shift->SUPER::query_parameters(@_);
}
sub parameters_raw {
    my $self = shift;
    $self->env->{'plack.request.merged'} ||= do {
        my $query = $self->SUPER::query_parameters;
        my $body  = $self->SUPER::body_parameters;
        Hash::MultiValue->new($query->flatten, $body->flatten);
    };
}
sub param_raw {
    my $self = shift;

    return keys %{ $self->parameters_raw } if @_ == 0;

    my $key = shift;
    return $self->parameters_raw->{$key} unless wantarray;
    return $self->parameters_raw->get_all($key);
}

1;
__END__

=encoding utf8

=head1 NAME

Slug::Request - Request！

=head1 SYNOPSIS

  use Slug::Request;
  my $req = Slug::Request->new($env);
  $req->uri_for('user, [name => "hisaichi5518"]);
  $req->uri_with([name => "hisaichi5518"]);
  $req->new_response(200,[],[]);
  $req->args;

=head1 DESCRIPTION

Plack::Requestを継承してるよ！そっちも見てね！

=head1 METHOD

=head2 uri_for

=head2 uri_with

=head2 new_response

=head2 args

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
