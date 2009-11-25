package local::lib::environment;

use strict;
use warnings;
use Params::Validate qw/validate
                        SCALAR/;
use local::lib;
use File::Path;
use autodie;
use Carp;

=head1 NAME

local::lib::environment - module catchphrase

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

describe the module, working code example

=cut

=head1 DESCRIPTION

=cut

=head1 FUNCTIONS

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
    upgrade_to_environment($args{directory});

} # end of subroutine make_environment


=head2 upgrade_to_environment

Upgrades a local lib directory into a full environment

=cut

sub upgrade_to_environment {
    my %args = validate(@_,
        {
            directory => {
                type => SCALAR
            }
        }
    );

    File::Path::mkpath($args{directory} . '/bin');

    open (my $activate_fh, '>', $args{directory} . '/bin/lle_activate');

    print $activate_fh, q| 
# This file must be used with "source bin/activate" *from bash*
# you cannot run it directly

deactivate () {
    if [ -n "$_OLD_VIRTUAL_PATH" ] ; then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
        hash -r
    fi

    if [ -n "$_OLD_VIRTUAL_PS1" ] ; then
        PS1="$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
    if [ ! "$1" = "nondestructive" ] ; then
    # Self destruct!
        unset deactivate
    fi
}

# unset irrelavent variables
deactivate nondestructive

VIRTUAL_ENV="/home/potato/.virtualenvs/test"
export VIRTUAL_ENV

_OLD_VIRTUAL_PATH="$PATH"
PATH="$VIRTUAL_ENV/bin:$PATH"
export PATH

_OLD_VIRTUAL_PS1="$PS1"
if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
    # special case for Aspen magic directories
    # see http://www.zetadev.com/software/aspen/
    PS1="[`basename \`dirname \"$VIRTUAL_ENV\"\``] $PS1"
else
    PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"
fi
export PS1

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the $PATH changes we made may not be respected
if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
    hash -r
fi|

    close $activate_fh;
} # end of subroutine upgrade_to_environment



=head1 AUTHOR

Christopher Mckay (cmckay), C<< <potatohead@potatolan.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

perldoc local::lib::environment


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Christopher Mckay.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of local::lib::environment


