use strict;
use warnings;

use Test::More;
use FindBin;
{
    package MyApp::Web;
    use parent "Slug";
    sub startup {
        my ($self) = @_;
        $self->plugin("ConfigLoader" => {file => "$FindBin::Bin/config.pl"});
    }
}

my $c = MyApp::Web->new;
$c->startup;
is_deeply $c->stash('config'), {hoge => 1};

done_testing;
