use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'local::lib::environment',
    license             => 'perl',
    dist_author         => q{Christopher Mckay <potatohead@potatolan.com>},
    dist_version_from   => 'lib/local/lib/environment.pm',
    requires => {
        'local::lib' => 0,
        'autodie' => 0,
        'Params::Validate' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'local-lib-environment-*' ],
    create_makefile_pl => 'traditional',
);

$builder->add_build_element('sh');
$builder->create_build_script();
