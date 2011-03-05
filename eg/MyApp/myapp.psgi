use lib "./lib";
use strict;
use warnings;
use Plack::Builder;
use MyApp::Web;

builder {
    MyApp::Web->to_app;
}
