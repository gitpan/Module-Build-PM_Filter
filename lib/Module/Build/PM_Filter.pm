package Module::Build::PM_Filter;
use base qw(Module::Build);
use strict;
use warnings;
use Carp;
use utf8;
use English;

our $VERSION = '0.5';

sub process_pm_files {
    my  $self   =   shift;
    my  $ext    =   shift;

    ### is there a pm_filter file ? ...
    if (not -x q(pm_filter)) {
        ### dispatch to super method ...
        return $self->SUPER::process_pm_files( $ext );
    }

    my $method = "find_${ext}_files";
    my $files = $self->can($method) ? $self->$method() :
                $self->_find_file_by_type($ext,  'lib');

    ### the method for find pm files is: $method
    ### and the pm files are: $files

    while (my ($file, $dest) = each %$files) {
        ### first copy the source to the target ...
        if (my $target = $self->copy_if_modified( from => $file,
                         to =>  File::Spec->catfile($self->blib, $dest))) {
            ### do filtering ...
            $self->_do_filter( $file, $target );
        }
    }
}

sub process_script_files {
    my  $self   =   shift;

    ### is there a pm_filter file ? ...
    if (not -x q(pm_filter)) {
        ### dispatch to super method ...
        return $self->SUPER::process_script_files( );
    }

    # find script files 
    my  $files  =   $self->find_script_files;

    # do nothing if not found anything
    return if not keys( %{ $files });

    my $script_dir = File::Spec->catdir($self->blib, 'script');
    File::Path::mkpath( $script_dir );

    foreach my $file (keys %$files) {
        if (my $result = $self->copy_if_modified($file, $script_dir, 'flatten')) {
            $self->_do_filter( $file, $result );
            $self->fix_shebang_line($result);
            $self->make_executable($result);
        }
    }   
}

sub _do_filter {
    my  $self       =   shift;
    my  $source     =   shift;
    my  $target     =   shift;
    my  $cmd        =   sprintf("./pm_filter < %s > %s", $source, $target);

    if (not $self->do_system($cmd)) {
        croak "pm_filter failed: ${ERRNO}";
    }                

    return;
}

1;
__END__

=head1 NAME

Module::Build::PM_Filter - Add a PM_Filter feature to Module::Build

=head1 SYNOPSIS

In a Build.PL file you must use this module in place of the L<Module::Build>:

    use Module::Build::PM_Filter;

    my $build = Module::Build::PM_Filter->new(
                module_name         =>  'MyIkiWiki::Tools',
                license             =>  q(gpl),
                dist_version        =>  '0.2',
                dist_author         =>  'Víctor Moral <victor@taquiones.net>',
                );

    $build->create_build_script();

In the package directory build a pm_filter file like this:

    #!/usr/bin/perl -pl

    s{##PACKAGE_LIB##}{use lib qw(/usr/share/myprogram);}g;

and change its permissions for user execution.    

Then in a script from package insert a line like this:

    package MyPackage;
    use strict;
    use base;

    ...

    ##PACKAGE_LIB##

    ...

=head1 DESCRIPTION

This module provides a Module::Build compatible class and adds a filter for pm
files. The filter could be used to replace Perl source from development
environment to production.

In the debug phase we can play with the application and modules without
mattering to us where the library are; when we build the package for
distribution, the modules and the scripts will contain the correct path in the
final location.

=head1 SUBRUTINES/METHODS

=head2 process_pm_files( )

This method looks for a file named 'pm_filter' in the current work directory and
executes it; his standard input is redirected to the source pm and his standard
output is redirected to a temp file. 

The temp file is finally installed on the F<blib/> tree.

=head2 process_script_files( )

This method finds, filters and install the executable files in the package.

=head1 DIAGNOSTICS

=over

=item pm_filter failed ...

croak with this text when it could not run the pm_filter program.

=back

=head1 DEPENDENCIES

=over 

=item Module::Build

=back

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.
Please report problems to the author.
Patches are welcome.

=head1 AUTHOR

Víctor Moral <victor@taquiones.net>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005 "Víctor Moral" <victor@taquiones.net>

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.


This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.


You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 US

