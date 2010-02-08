use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'local::lib::profiles',
    license             => 'perl',
    dist_author         => q{Christopher Mckay <potatohead@potatolan.com>},
    dist_version_from   => 'lib/local/lib/profiles.pm',
    requires => {
        'local::lib' => 0,
        'autodie' => 0,
        'Params::Validate' => 0,
        'File::Util' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'local-lib-profiles-*' ],
    create_makefile_pl => 'traditional',
);

$builder->add_build_element('sh');
$builder->create_build_script();
