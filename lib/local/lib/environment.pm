package local::lib::environment;

use strict;
use warnings;
use Params::Validate qw/validate
                        SCALAR/;
use local::lib;
use File::Copy;
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
    upgrade_to_environment(directory => $args{directory});

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

    my $activate_script = find_activate_script();

    File::Path::mkpath($args{directory} . '/bin');

    copy($activate_script, $args{directory} . '/bin/activate');

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


