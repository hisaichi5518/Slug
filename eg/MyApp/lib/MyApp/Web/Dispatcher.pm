package MyApp::Web::Dispatcher;
use strict;
use warnings;

use Slug::Route::RSimple qw( connect submapper dispatch );
connect("/" => {controller => "Root", action => "index"});






1;
