#line 1
## Support for Perldoc POD Generation
#
# This module adds a `perldoc` target to the `Makefile` for authors.
# This means that `make perldoc` will create `.pod` files from every
# `.pm` file with *Perldoc* style documentation.
#
# Synopsis:
# 
#     > make perldoc
#
# Copyright (c) 2007. Ingy döt Net. All rights reserved.
#
# Licensed under the same terms as Perl itself.

package Module::Install::Perldoc;

use strict;
use Module::Install::Base;
use File::Basename ();

use vars qw{$VERSION @ISA};
BEGIN {
    $VERSION = '0.10';
    @ISA     = qw{Module::Install::Base};
}

## Support for author side Perldoc management
sub perldoc {
    my $self = shift;
    require File::Find;

    # Need to find all the .pm files at `perl Makefile.PL` time
    my @pms = glob('*.pm');
    File::Find::find( sub {
        push @pms, $File::Find::name if /\.pm$/i;
    }, 'lib');

    my $postamble = <<'.';
doc :: perldoc
pod :: perldoc
perldoc ::
.

    # Add actions for `make perldoc`
    for my $pm (@pms) {
        $postamble .= <<".";
\t\@\$(PERL) -Ilib -MPerldoc::Make=pm_into_pod - $pm
.
    }

    $self->postamble($postamble)
        if @pms;
}

1;
