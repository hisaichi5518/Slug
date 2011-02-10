use strict;
use warnings;
use Test::More;

use Slug;
use Slug::Trigger;
use Slug::Response;

my $s = Slug->new;

is $s->encoding, "utf-8";
is $s->html_content_type, "text/html; charset=UTF-8";
is $s->encode_fb->(), undef;
is_deeply $s->trigger, Slug::Trigger->new;
is_deeply $s->not_found, Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
is_deeply $s->not_found(0), Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
is_deeply $s->not_found(""), Slug::Response->new(404,['Content-Length' => 14],["404 Not Found!"]);
is_deeply $s->not_found("hoge"), Slug::Response->new(404,['Content-Length' => 4],["hoge"]);

for my $i (0 .. 50) {
    $s->stash($i => $i);
    is $s->stash($i), $i;
    is $s->stash->{$i}, $i;
}
done_testing;
