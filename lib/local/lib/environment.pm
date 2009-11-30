package local::lib::environment;

use strict;
use warnings;
use Params::Validate qw/validate
                        SCALAR/;
use local::lib;
use File::Copy;
use File::Path;
use File::Util;
use autodie;
use Carp;

=head1 NAME

local::lib::environment - makes modules feel at home

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

describe the module, working code example

=cut

=head1 DESCRIPTION

local::lib::environment is designed to extend upon the methodologies of
lib::local to make it simpler to create, manage, and discard local perl
environments. 

=cut

=head1 COMMANDS

These are the cmd line usages for the package

=cut

=head2 local-lib_mkenv

This will create an environment under the LOCAL_LIB_HOME directory by the given
name.

=cut

=head2 local-lib_rmenv

This will remove an environment that lives under the LOCAL_LIB_HOME directory 
by the given name.

=cut

=head2 local-lib_workon

This will activate a previously created environment.

=cut

=head2 local-lib_deactivate

This will deactivate the currently active environment. Note that this is only
available if an environment is active

=cut

=head1 ROUTINES

=cut

=head2 make_environment

Creates a new local lib environment in the supplied directory

=cut

sub make_environment {
    my %args = validate(@_,
        {
            directory => {
                type => SCALAR
            }
        }
    );
    
    # create base local lib
    local::lib->ensure_dir_structure_for($args{directory});

    # then upgrade it to a local lib environment
    upgrade_environment(directory => $args{directory});

} # end of subroutine make_environment


=head2 find_activate_script

Finds the path of the activate.sh script

=cut

sub find_activate_script {
    my %args = validate(@_,
        {

        }
    );

    my @lib_paths = split /:/, $ENV{PERL5LIB};

    foreach (@lib_paths)
    {
        if (-e $_.'/local/lib/environment/activate.sh')
        {
            return $_.'/local/lib/environment/activate.sh';
        }
    }

    die "No activate.sh script found in library paths";
} # end of subroutine find_activate_script


=head2 upgrade_environment

Upgrades a local lib directory into a full environment

=cut

sub upgrade_environment {
    my %args = validate(@_,
        {
            directory => {
                type => SCALAR
            }
        }
    );

    my $activate_script = find_activate_script();

    File::Path::mkpath($args{directory} . '/bin');

    deploy_support_file(
        source => $activate_script,
        destination => $args{directory}.'/bin/local-lib_activate',
        environment_location => $args{directory}
    )

} # end of subroutine upgrade_environment



=head2 deploy_support_file

takes a support file from a given local (like lib/activate.sh or the templates
directory), substitutes the content tokens that it finds, then writes the file
to the required destination

=cut

sub deploy_support_file {
    my %args = validate(@_,
        {
            source => {
                type => SCALAR
            },
            destination => {
                type => SCALAR
            },
            environment_location => {
                type => SCALAR
            }
        }
    );

    #open the source of the file
    my $file = File::Util->new();
    my $support_file = $file->load_file($args{source});

    #substitute the tokens
    $support_file =~ s/__PERL_ENV__/$args{environment_location}/g;

    #write to its destination
    $file->write_file(
        file => $args{destination},
        content => $support_file
    );

} # end of subroutine deploy_support_file



=head1 AUTHOR

Christopher Mckay (cmckay), C<< <potatohead@potatolan.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

perldoc local::lib::environment


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright Doug Hellmann, All Rights Reserved

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of Doug Hellmann not be used
in advertising or publicity pertaining to distribution of the software
without specific, written prior permission.

Copyright 2009 Christopher Mckay.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

# End of local::lib::environment


