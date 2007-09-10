#!/usr/bin/perl

use lib qw(lib);

use Test::More qw(no_plan);
use Module::Build::PM_Filter;

# change to the examples directory
chdir q(examples);
my $class = q(Module::Build::PM_Filter);

my $builder = $class->new(
    module_name         => 'MyModule',
    license             => 'gpl',
    dist_author         => 'Víctor Moral <victor@taquiones.net>',
    dist_version_from   => 'lib/MyModule.pm',
    requires => {
        'Test::More'                =>  0,
        'Module::Build::PM_Filter'  =>  0,
    },
    add_to_cleanup      => [ 'MyModule-*' ],
);

isa_ok($builder, $class);

#$builder->create_build_script();
#
#ok(-e q(Build.PL), "creating the Build.PL script");
#
#SKIP: {
#    eval { use Module::Build::PM_Filter 0.7; };
#
#    skip "old version of Module::Build::PM_Filter" if $@;
#
#
#
#    $builder->dispatch('build');
#
#    ok(-e q(Build), "building and filtering the package");
#
#    #ok($builder->dispatch('test'), 'test the package' );
#
#    ok($builder->dispatch('disttest'), 'test the distribution' );
#
#    $builder->dispatch('distclean');
#
#    my $all_clean = not -e $builder->dist_dir();
#
#    ok($all_clean, "distribution cleaning");
#}
