sub author_tests  { }
sub readme_from   { }
sub auto_set_repository { }
use inc::Module::Install;

name 'Slug';
all_from 'lib/Slug.pm';
readme_from 'lib/Slug.pm';
license 'perl';

requires "Plack"  => 0.9943;
requires "Encode";
requires "parent" => 0.223;
requires "Router::Simple" => 0.06;
requires "Tiffany"        => 0.02;
requires "Text::Xslate"   => 0.1056;

test_requires 'Test::More' => 0.88;
test_requires 'Test::WWW::Mechanize::PSGI';

tests 't/*.t t/*/*.t t/*/*/*.t';
author_tests 'xt';

no_index directory => 'eg';
auto_include;
WriteAll;