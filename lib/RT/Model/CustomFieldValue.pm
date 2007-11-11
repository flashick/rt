use warnings;
use strict;

# BEGIN BPS TAGGED BLOCK {{{
# 
# COPYRIGHT:
#  
# This software is Copyright (c) 1996-2007 Best Practical Solutions, LLC 
#                                          <jesse@bestpractical.com>
# 
# (Except where explicitly superseded by other copyright notices)
# 
# 
# LICENSE:
# 
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
# 
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/copyleft/gpl.html.
# 
# 
# CONTRIBUTION SUBMISSION POLICY:
# 
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
# 
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
# 
# END BPS TAGGED BLOCK }}}
use warnings;
use strict;

package RT::Model::CustomFieldValue;

no warnings qw/redefine/;
use base qw/RT::Record/;
sub table { 'CustomFieldValues' }
use Jifty::DBI::Schema;
use Jifty::DBI::Record schema {
    column Creator =>  type is 'int(11)', max_length is 11, default is '0';
    column LastUpdatedBy =>  type is 'int(11)', max_length is 11, default is '0';
    column SortOrder =>  type is 'int(11)', max_length is 11, default is '0';
    column CustomField =>  type is 'int(11)', max_length is 11, default is '0';
    column Created =>  type is 'datetime',  default is '';
    column LastUpdated =>  type is 'datetime',  default is '';
    column Name =>  type is 'varchar(200)', max_length is 200, default is '';
    column Description =>  type is 'varchar(255)', max_length is 255, default is '';

};


=head2 ValidateName

Override the default ValidateName method that stops custom field values
from being integers.

=cut

sub create {
    my $self = shift;
    my %args = (
        CustomField => 0,
        Name        => '',
        Description => '',
        SortOrder   => 0,
        Category    => '',
        @_,
    );

    my $cf_id = ref $args{'CustomField'}? $args{'CustomField'}->id: $args{'CustomField'};

    my $cf = RT::Model::CustomField->new( $self->current_user );
    $cf->load( $cf_id );
    unless ( $cf->id ) {
        return (0, $self->loc("Couldn't load Custom Field #[_1]", $cf_id));
    }
    unless ( $cf->current_user_has_right('AdminCustomField') ) {
        return (0, $self->loc('Permission denied'));
    }

    my ($id, $msg) = $self->SUPER::create(
        CustomField => $cf_id,
        map { $_ => $args{$_} } qw(Name Description SortOrder)
    );
    return ($id, $msg) unless $id;

    if ( defined $args{'Category'} && length $args{'Category'} ) {
        # $self would be loaded at this stage
        my ($status, $msg) = $self->set_Category( $args{'Category'} );
        unless ( $status ) {
            $RT::Logger->error("Couldn't set category: $msg");
        }
    }

    return ($id, $msg);
}

sub Category {
    my $self = shift;
    my $attr = $self->first_attribute('Category') or return undef;
    return $attr->Content;
}

sub set_Category {
    my $self = shift;
    my $category = shift;
    if ( defined $category && length $category ) {
        return $self->set_attribute(
            Name    => 'Category',
            Content => $category,
        );
    }
    else {
        my ($status, $msg) = $self->delete_attribute( 'Category' );
        unless ( $status ) {
            $RT::Logger->warning("Couldn't delete atribute: $msg");
        }
        # return true even if there was no category
        return (1, $self->loc('Category unset'));
    }
}

sub validate_Name {
    return defined $_[1] && length $_[1];
};

1;


