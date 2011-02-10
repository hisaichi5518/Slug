package Slug::Util::Accessor;
use strict;
use warnings;

sub import {
    shift;
    return unless @_;
    mk_accessors( scalar caller(0), @_ );
}

sub mk_accessors {
    my ($package, $args) = @_;
    no strict 'refs';
    while (my($field, $value) = each %$args) {
        *{ $package . '::' . $field } = sub {
            return $_[0]->{ $field } = (ref($value) eq 'CODE' ? $value->($_[0]) : $value)
                if scalar( @_ ) == 1 && !($_[0]->{ $field }) && defined $value;
            return $_[0]->{ $field } if scalar( @_ ) == 1;
            return $_[0]->{ $field }  = scalar( @_ ) == 2 ? $_[1] : [ @_[1..$#_] ];
        };
    }
}

1;
__END__
=encoding utf8

=head1 NAME

Slug::Util::Accessor - Accessor

=head1 SYNOPSIS

  package MyApp::Web;
  use parent "Slug";
  
  use Slug::Util::Accessor {
    res_200 => sub { shift->new_response(200) },
    str     => "string!",
  };

  sub starup {
    my $self = shift;
    $self->res_200;
  }

=head1 DESCRIPTION

最初から値が設定されてるアクセサを作るよ。
デフォルトが必要ない場合は、 L<Plack::Util::Accessor> を使えばいいよ。

=head1 SEE ALSO

L<Class::Accessor::Lite> L<Plack::Util::Accessor>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
