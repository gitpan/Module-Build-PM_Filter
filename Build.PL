use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Module::Build::PM_Filter',
    license             => 'perl',
    dist_author         => 'Víctor Moral <victor@taquiones.net>',
    dist_version_from   => 'lib/Module/Build/PM_Filter.pm',
    requires => {
        'Test::More'    =>  0,
        'Module::Build' =>  0,
    },
    add_to_cleanup      => [ 'Module-Build-PM_Filter-*' ],
);

$builder->create_build_script();
