package MyApp::Web::Controller::Root;
use strict;
use warnings;

sub index {
    my ($self, $c) = @_;
    $c->create_response(
        200,
        ["Content-Type" => $c->html_content_type],
        ["<html><head></head><body>ok!</body></html>"]
    );
}

sub hoge {
    my ($self, $c) = @_;
    $c->create_response(
        200,
        ["Content-Type" => $c->html_content_type],
        ["<html><head></head><body>hoge!</body></html>"]
    );
}
sub not_found {
    my ($self, $c) = @_;
    $c->not_found;
}
sub change_status1 {
    my ($self, $c) = @_;
    my $res = $c->create_response(
        404,
        ["Content-Type" => $c->html_content_type],
        ["<html><head></head><body>404!</body></html>"]
    );
    $res->status(200);
}

sub change_status2 {
    my ($self, $c) = @_;
    $c->create_response(
        404,
        ["Content-Type" => $c->html_content_type],
        ["<html><head></head><body>404!</body></html>"]
    );
    $c->res->status(200);
}
sub change_status3 {
    my ($self, $c) = @_;
    $c->create_response(
        404,
        ["Content-Type" => $c->html_content_type],
        ["<html><head></head><body>404!</body></html>"]
    )->status(200);
}
sub check_env {
    my ($self, $c) = @_;
    $c->create_response(
        200,
        [],
        [$c->req->env->{'slug.test_plugin'}]
    );
}
sub myapp_web_dispatcher {
    my ($self, $c) = @_;
    $c->create_response(
        200,
        [],
        ["<html><head></head><body>ok!</body></html>"]
    );
}

1;
