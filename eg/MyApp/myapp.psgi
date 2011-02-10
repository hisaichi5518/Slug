use lib "./lib";
use strict;
use warnings;
use Plack::Builder;
use MyApp::Web;

builder {
    enable 'Plack::Middleware::Debug';
    MyApp::Web->to_app;
}
