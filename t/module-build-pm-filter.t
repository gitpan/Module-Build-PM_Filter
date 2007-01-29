#!/usr/bin/perl

use lib qw(lib);

use Test::More tests => 1;

my $class = q(Module::Build::PM_Filter);

use_ok( $class );

# my $builder = $class->new( module_name => 'Coco' );

# isa_ok( $builder, $class);


