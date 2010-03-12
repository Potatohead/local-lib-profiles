package local::lib::profiles;

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

local::lib::profiles - makes modules feel at home

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';


=head1 SYNOPSIS

describe the module, working code example

=cut

=head1 DESCRIPTION

local::lib::profiles is designed to extend upon the methodologies of
lib::local to make it simpler to create, manage, and discard local perl
profiles.

=cut

# Embedding the activate script in a value to be written to a file
# all values in it are escaped so to edit s/\\\$/\$/g and reverse to store back
# the way it's escaped
my $activate_script = <<ACT_HD;
# This file must be used with "source bin/activate" *from bash*
# you cannot run it directly

ll_deactivate () {
    if [ -n "\$_OLD_PATH" ] ; then
        PATH="\$_OLD_PATH"
        export PATH
        unset _OLD_PATH
    fi
    if [ -n "\$_OLD_MODULEBUILDRC" ] ; then
        MODULEBUILDRC="\$_OLD_MODULEBUILDRC"
        export MODULEBUILDRC
        unset _OLD_MODULEBUILDRC
    fi
    if [ -n "\$_OLD_PERL_MM_OPT" ] ; then
        PERL_MM_OPT="\$_OLD_PERL_MM_OPT"
        export PERL_MM_OPT
        unset _OLD_PERL_MM_OPT
    fi
    if [ -n "\$_OLD_PERL5LIB" ] ; then
        PERL5LIB="\$_OLD_PERL5LIB"
        export PERL5LIB
        unset _OLD_PERL5LIB
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the \$PATH changes we made may not be respected
    if [ -n "\$BASH" -o -n "\$ZSH_VERSION" ] ; then
        hash -r
    fi

    if [ -n "\$_OLD_PS1" ] ; then
        PS1="\$_OLD_PS1"
        export PS1
        unset _OLD_PS1
    fi

    unset PERL_PROFILE
    if [ ! "\$1" = "nondestructive" ] ; then
    # Self destruct!
        unset -f ll_deactivate
    fi
}

# unset irrelavent variables
ll_deactivate nondestructive

PERL_PROFILE="__PERL_PROFILE__"
export PERL_PROFILE

_OLD_PATH="\$PATH"

_OLD_PS1="\$PS1"
if [ "`basename \"\$PERL_PROFILE\"`" = "__" ] ; then
    # special case for Aspen magic directories
    # see http://www.zetadev.com/software/aspen/
    PS1="[`basename \`dirname \"\$PERL_PROFILE\"\``] \$PS1"
else
    PS1="(`basename \"\$PERL_PROFILE\"`)\$PS1"
fi
export PS1

_OLD_MODULEBUILDRC="\$MODULEBUILDRC"
export _OLD_MODULEBUILDRC
_OLD_PERL_MM_OPT="\$PERL_MM_OPT"
export _OLD_PERL_MM_OPT
_OLD_PERL5LIB="\$PERL5LIB"
export _OLD_PERL5LIB


eval \$( perl -Mlocal::lib=\$PERL_PROFILE)

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the \$PATH changes we made may not be respected
if [ -n "\$BASH" -o -n "\$ZSH_VERSION" ] ; then
    hash -r
fi
ACT_HD

=head1 COMMANDS

These are the cmd line usages for the package

=head2 ll_mkprofile

Creates a profile under the LOCAL_LIB_HOME directory by the given
name.

=head2 ll_rmprofile

Removes a profile that lives under the LOCAL_LIB_HOME directory 
by the given name.

=head2 ll_workon

Activates a previously created profile.

=head2 ll_deactivate

Deactivate the currently active profile. Note that this is only
available if an profile is active

=head2 ll_upgrade_profile

Replaces or create the Active scripts in a given local-lib profile.
This can be used to either turn a local-lib library into a full blown
profile or to take an existing profile and upgrade it to contain more
recent scripts

=head2 ll_cdprofile

Changes directory into the root of the profile

=head1 ROUTINES

=cut

=head2 make_profile

Creates a new local lib profile in the supplied directory

=cut

sub make_profile {
    my %args = validate(@_,
        {
            directory => {
                type => SCALAR
            }
        }
    );
    
    # create base local lib
    local::lib->ensure_dir_structure_for($args{directory});

    # then upgrade it to a local lib profile
    upgrade_profile(directory => $args{directory});

} # end of subroutine make_profile


=head2 upgrade_profile

Upgrades a local lib directory into a full profile

=cut

sub upgrade_profile {
    my %args = validate(@_,
        {
            directory => {
                type => SCALAR
            }
        }
    );

    File::Path::mkpath($args{directory} . '/bin');

    deploy_support_file(
        source => $activate_script,
        destination => $args{directory}.'/bin/ll_activate',
        profile_location => $args{directory}
    )

} # end of subroutine upgrade_profile



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
            profile_location => {
                type => SCALAR
            }
        }
    );

    # File::Util cannot handle // in its file paths, so gotta replace them
    $args{destination} =~ s/\/\//\//g;

    my $file = File::Util->new();

    #substitute the tokens
    $args{source} =~ s/__PERL_PROFILE__/$args{profile_location}/g;

    #write to its destination
    $file->write_file(
        file => $args{destination},
        content => $args{source}
    );

} # end of subroutine deploy_support_file



=head1 AUTHOR

Please contribute patches to Github:

    http://github.com/Potatohead/local-lib-profiles

Christopher Mckay (cmckay), C<< <potatohead@potatolan.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

perldoc local::lib::profiles

=head1 BUGS

=over 4

=item Colons in profile names

This breaks the profile creation, just don't do it untill I fix it.

=back

=head1 ACKNOWLEDGEMENTS

This code is largely modeled upon, and in places copied from, work by Doug 
Hellmann in his virtualenvwrapper python package

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

# End of local::lib::profiles
