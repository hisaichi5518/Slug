use strict;
use warnings;
use utf8;

use Test::More;
use Encode qw(encode);
{
    package MyApp::Web;
    use parent "Slug";
    use utf8;

    sub startup {
        my ($self) = @_;
        $self->encoding('shift_jis');
        $self->html_content_type("text/html; charset=Shift_JIS");
        $self->ok($self->encode("日本語"));
    }
}

my $c   = MyApp::Web->new;
my $res = MyApp::Web->to_app->({});
is $res->[0], 200;
is_deeply +{@{$res->[1]}}, +{@{["Content-Type" => "text/html; charset=Shift_JIS", "Content-Length" => 6]}};
is_deeply $res->[2], [encode('shift_jis', "日本語")];

done_testing;

#isa_ok $c->encoding('shift_jis'), "Encode::XS";
#is $c->encoding->mime_name, "Shift_JIS";
#isa_ok $c->encoding('cp932'), "Encode::XS";
#eval { $c->encoding('hoge') };
#like $@, qr/encoding 'hoge' not found/;
