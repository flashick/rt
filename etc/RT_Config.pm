#
# WARNING: NEVER EDIT RT_Config.pm. Instead, copy any sections you want to change to RT_SiteConfig.pm
# and edit them there.
#

package RT;

=head1 name

RT::Config

=for testing

use RT::Config;

=cut

# {{{ Base Configuration

# $rtname is the string that RT will look for in mail messages to
# figure out what ticket a new piece of mail belongs to

# Your domain name is recommended, so as not to pollute the namespace.
# once you start using a given tag, you should probably never change it.
# (otherwise, mail for existing tickets won't get put in the right place

set( $rtname, "example.com" );

# This regexp controls what subject tags RT recognizes as its own.
# If you're not dealing with historical $rtname values, you'll likely
# never have to enable this feature.
#
# Be VERY CAREFUL with it. Note that it overrides $rtname for subject
# token matching and that you should use only "non-capturing" parenthesis
# grouping. For example:
#
#     set($EmailSubjectTagRegex, qr/(?:example.com|example.org)/i );
#
# and NOT
#
#     set($EmailSubjectTagRegex, qr/(example.com|example.org)/i );
#
# This setting would make RT behave exactly as it does without the
# setting enabled.
#
# set($EmailSubjectTagRegex, qr/\Q$rtname\E/i );

# You should set this to your organization's DNS domain. For example,
# fsck.com or asylum.arkham.ma.us. It's used by the linking interface to
# guarantee that ticket URIs are unique and easy to construct.

set( $organization, "example.com" );

# $MinimumpasswordLength defines the minimum length for user
# passwords. setting it to 0 disables this check
set( $MinimumpasswordLength, "5" );

# $Timezone is used to convert times entered by users into GMT and back again
# It should be set to a timezone recognized by your local unix box.
set( $Timezone, 'US/Eastern' );

# }}}

# {{{ Database Configuration

# Database driver being used; case matters.  Valid types are "mysql",
# "Oracle" and "Pg"

set( $DatabaseType, 'mysql' );

# The domain name of your database server
# If you're running mysql and it's on localhost,
# leave it blank for enhanced performance
set( $DatabaseHost,   'localhost' );
set( $DatabaseRTHost, 'localhost' );

# The port that your database server is running on.  Ignored unless it's
# a positive integer. It's usually safe to leave this blank
set( $DatabasePort, '' );

#The name of the database user (inside the database)
set( $DatabaseUser, 'rt_user' );

# password the DatabaseUser should use to access the database
set( $Databasepassword, 'rt_pass' );

# The name of the RT's database on your database server
set( $Databasename, 'rt3' );

# If you're using Postgres and have compiled in SSL support,
# set DatabaseRequireSSL to 1 to turn on SSL communication
set( $DatabaseRequireSSL, undef );

# }}}

# {{{ Incoming mail gateway configuration

# OwnerEmail is the address of a human who manages RT. RT will send
# errors generated by the mail gateway to this address.  This address
# should _not_ be an address that's managed by your RT instance.

set( $OwnerEmail, 'root' );

# If $LoopsToRTOwner is defined, RT will send mail that it believes
# might be a loop to $OwnerEmail

set( $LoopsToRTOwner, 1 );

# If $StoreLoops is defined, RT will record messages that it believes
# to be part of mail loops.
# As it does this, it will try to be careful not to send mail to the
# sender of these messages

set( $StoreLoops, undef );

# $MaxAttachmentSize sets the maximum size (in bytes) of attachments stored
# in the database.

# For mysql and oracle, we set this size at 10 megabytes.
# If you're running a postgres version earlier than 7.1, you will need
# to drop this to 8192. (8k)

set( $MaxAttachmentSize, 10000000 );

# $TruncateLongAttachments: if this is set to a non-undef value,
# RT will truncate attachments longer than MaxAttachmentSize.

set( $TruncateLongAttachments, undef );

# $DropLongAttachments: if this is set to a non-undef value,
# RT will silently drop attachments longer than MaxAttachmentSize.

set( $DropLongAttachments, undef );

# If $ParseNewMessageForTicketCcs is true, RT will attempt to divine
# Ticket 'Cc' watchers from the To and Cc lines of incoming messages
# Be forewarned that if you have _any_ addresses which forward mail to
# RT automatically and you enable this option without modifying
# "RTAddressRegexp" below, you will get yourself into a heap of trouble.

set( $ParseNewMessageForTicketCcs, undef );

# RTAddressRegexp is used to make sure RT doesn't add itself as a ticket CC if
# the setting above is enabled.

set( $RTAddressRegexp, '^rt\@example.com$' );

# RT provides functionality which allows the system to rewrite
# incoming email addresses.  In its simplest form,
# you can substitute the value in canonicalize_emailReplace
# for the value in canonicalize_emailMatch
# (These values are passed to the canonicalize_email subroutine in RT/User.pm)
# By default, that routine performs a s/$Match/$Replace/gi on any address passed to it

#set($canonicalize_emailMatch , '@subdomain\.example\.com$');
#set($canonicalize_emailReplace , '@example.com');

# set this to true and the create new user page will use the values that you
# enter in the form but use the function canonicalize_UserInfo in User_Local.pm
set( $canonicalize_OnCreate, 0 );

# If $SenderMustExistInExternalDatabase is true, RT will refuse to
# create non-privileged accounts for unknown users if you are using
# the "LookupSenderInExternalDatabase" option.
# Instead, an error message will be mailed and RT will forward the
# message to $RTOwner.
#
# If you are not using $LookupSenderInExternalDatabase, this option
# has no effect.
#
# If you define an AutoRejectRequest template, RT will use this
# template for the rejection message.

set( $SenderMustExistInExternalDatabase, undef );

# @MailPlugins is a list of auth plugins for L<RT::Interface::Email>
# to use; see L<rt-mailgate>

# $UnsafeEmailCommands, if set to true, enables 'take' and 'resolve'
# as possible actions via the mail gateway.  As its name implies, this
# is very unsafe, as it allows email with a forged sender to possibly
# resolve arbitrary tickets!

# }}}

# {{{ Outgoing mail configuration

# $MailCommand defines which method RT will use to try to send mail.
# We know that 'sendmailpipe' works fairly well.  If 'sendmailpipe'
# doesn't work well for you, try 'sendmail'.  Other options are 'smtp'
# or 'qmail'.
#
# Note that you should remove the '-t' from $SendmailArguments
# if you use 'sendmail' rather than 'sendmailpipe'

set( $MailCommand, 'sendmailpipe' );

# {{{ Sendmail Configuration
# These options only take effect if $MailCommand is 'sendmail' or
# 'sendmailpipe'

# $SendmailArguments defines what flags to pass to $SendmailPath
# If you picked 'sendmailpipe', you MUST add a -t flag to $SendmailArguments
# These options are good for most sendmail wrappers and workalikes
set( $SendmailArguments, "-oi -t" );

# These arguments are good for sendmail brand sendmail 8 and newer
#set($SendmailArguments,"-oi -t -ODeliveryMode=b -OErrorMode=m");

# $SendmailBounceArguments defines what flags to pass to $Sendmail
# assuming RT needs to send an error (ie. bounce).
set( $SendmailBounceArguments, '-f "<>"' );

# If you selected 'sendmailpipe' above, you MUST specify the path to
# your sendmail binary in $SendmailPath.
set( $SendmailPath, "/usr/sbin/sendmail" );

# }}}

# {{{ SMTP configuration
# These options only take effect if $MailCommand is 'smtp'

# $SMTPServer should be set to the hostname of the SMTP server to use
set( $SMTPServer, undef );

# $SMTPFrom should be set to the 'From' address to use, if not the
# email's 'From'
set( $SMTPFrom, undef );

# $SMTPDebug should be set to true to debug SMTP mail sending
set( $SMTPDebug, 0 );

# }}}

# {{{ Other mailer configuration
# @MailParams defines a list of options passed to $MailCommand if it
# is not 'sendmailpipe', 'sendmail', or 'smtp'
set( @MailParams, () );

# }}}

# RT is designed such that any mail which already has a ticket-id associated
# with it will get to the right place automatically.

# $correspond_address and $comment_address are the default addresses
# that will be listed in From: and Reply-To: headers of correspondence
# and comment mail tracked by RT, unless overridden by a queue-specific
# address.

set( $correspond_address, 'RT_correspond_addressNotset' );

set( $comment_address, 'RT_comment_addressNotset' );

# By default, RT sets the outgoing mail's "From:" header to
# "Sendername via RT".  setting this option to 0 disables it.

set( $UseFriendlyFromLine, 1 );

# sprintf() format of the friendly 'From:' header; its arguments
# are Sendername and Senderemail.
set( $FriendlyFromLineFormat, "\"%s via RT\" <%s>" );

# RT can optionally set a "Friendly" 'To:' header when sending messages to
# Ccs or AdminCcs (rather than having a blank 'To:' header.

# This feature DOES NOT WORK WITH SENDMAIL[tm] BRAND SENDMAIL
# If you are using sendmail, rather than postfix, qmail, exim or some other MTA,
# you _must_ disable this option.

set( $UseFriendlyToLine, 0 );

# sprintf() format of the friendly 'From:' header; its arguments
# are WatcherType and TicketId.
set( $FriendlyToLineFormat,
    "\"%s of " . RT->config->get('rtname') . " Ticket #%s\":;" );

# By default, RT doesn't notify the person who performs an update, as they
# already know what they've done. If you'd like to change this behaviour,
# set $NotifyActor to 1

set( $NotifyActor, 0 );

# By default, RT records each message it sends out to its own internal database.
# To change this behavior, set $RecordOutgoingEmail to 0

set( $RecordOutgoingEmail, 1 );

# VERP support (http://cr.yp.to/proto/verp.txt)
# uncomment the following two directives to generate envelope senders
# of the form ${VERPPrefix}${originaladdress}@${VERPDomain}
# (i.e. rt-jesse=fsck.com@rt.example.com ) This currently only works
# with sendmail and sendmailppie.
# set($VERPPrefix, 'rt-');
# set($VERPDomain, $RT::organization);

# By default, RT forwards a message using queue's address and adds RT's tag into
# subject of the outgoing message, so recipients' replies go into RT as correspondents.
# To change this behavior, set $ForwardFromUser to 0 and RT will use address of the
# current user and leave subject without RT's tag.

set( $ForwardFromUser, 0 );

# }}}

# {{{ GnuPG
# A full description of the (somewhat extensive) GnuPG integration can be found by
# running the command
#
#  perldoc RT::Crypt::GnuPG  (or perldoc lib/RT/Crypt/GnuPG.pm from your RT install directory).

set(%GnuPG,
    Enable => 0,

    # set OutgoingMessagesFormat to 'inline' to use inline encryption and
    # signatures instead of 'RFC' (GPG/MIME: RFC3156 and RFC1847) format.
    OutgoingMessagesFormat => 'RFC',    # Inline

    # If you want to allow people to encrypt attachments inside the DB then
    # set below option to true value
    AllowEncryptDataInDB => 0,
);

# Options of GnuPG program
# If you override this in your RT_SiteConfig, you should be sure
# to include a homedir setting
# NOTE that options with '-' character MUST be quoted.

set(%GnuPGOptions,
    homedir => '/home/jesse/svk/3.999-DANGEROUS/var/data/gpg',

    # URL of a keyserver
    #    keyserver => 'hkp://subkeys.pgp.net',

    # enables the automatic retrieving of keys when encrypting
    #    'auto-key-locate' => 'keyserver',

    # enables the automatic retrieving of keys when verifying signatures
    #    'auto-key-retrieve' => undef,
);

# }}}

# {{{ Logging

# Logging.  The default is to log anything except debugging
# information to syslog.  Check the Log::Dispatch POD for
# information about how to get things by syslog, mail or anything
# else, get debugging info in the log, etc.

# It might generally make sense to send error and higher by email to
# some administrator.  If you do this, be careful that this email
# isn't sent to this RT instance.  Mail loops will generate a critical
# log message.

# The minimum level error that will be logged to the specific device.
# From lowest to highest priority, the levels are:
#  debug info notice warning error critical alert emergency
set( $LogToSyslog, 'debug' );
set( $LogToScreen, 'error' );

# Logging to a standalone file is also possible, but note that the
# file should needs to both exist and be writable by all direct users
# of the RT API.  This generally include the web server, whoever
# rt-crontool runs as.  Note that as rt-mailgate and the RT CLI go
# through the webserver, so their users do not need to have write
# permissions to this file. If you expect to have multiple users of
# the direct API, Best Practical recommends using syslog instead of
# direct file logging.

set( $LogToFile, undef );
set( $LogDir,    '/home/jesse/svk/3.999-DANGEROUS/var/log' );
set( $LogToFilenamed, "rt.log" );    #log to rt.log

# If set to a log level then logging will include stack
# traces for messages with level equal to or greater than
# specified.

set( $LogStackTraces, '' );

# On Solaris or UnixWare, set to ( socket => 'inet' ).  Options here
# override any other options RT passes to Log::Dispatch::Syslog.
# Other interesting flags include facility and logopt.  (See the
# Log::Dispatch::Syslog documentation for more information.)  (Maybe
# ident too, if you have multiple RT installations.)

set( @LogToSyslogConf, () );

# RT has rudimentary SQL statement logging support if you have
# DBIx-SearchBuilder 1.31_1 or higher; simply set $StatementLog to be
# the level that you wish SQL statements to be logged at.
set( $StatementLog, undef );

# }}}

# {{{ Web interface configuration

# This determines the default stylesheet the RT web interface will use.
# RT ships with two valid values by default:
#
#   3.5-default     The totally new, default layout for RT 3.5
#   3.4-compat      A 3.4 compatibility stylesheet to make RT 3.5 look
#                   (mostly) like 3.4
#
# This value actually specifies a directory in share/html/NoAuth/css/
# from which RT will try to load the file main.css (which should
# @import any other files the stylesheet needs).  This allows you to
# easily and cleanly create your own stylesheets to apply to RT.  This
# option can be overridden by users in their preferences.
set( $WebDefaultStylesheet, '3.5-default' );

# Define the directory name to be used for images in rt web
# documents.

# If you're putting the web ui somewhere other than at the root of
# your server, you should set $WebPath to the path you'll be
# serving RT at.
# $WebPath requires a leading / but no trailing /.
#
# In most cases, you should leave $WebPath set to '' (an empty value).

set( $WebPath, "" );

# If we're running as a superuser, run on port 80
# Otherwise, pick a high port for this user.

set( $WebPort, 80 );    # + ($< * 7274) % 32766 + ($< && 1024));

# This is the Scheme, server and port for constructing urls to webrt
# $WebBaseURL doesn't need a trailing /

set( $WebBaseURL, "http://localhost:" . RT->config->get('WebPort') );

set( $WebURL,
    RT->config->get('WebBaseURL') . RT->config->get('WebPath') . "/" );

# $WebImagesURL points to the base URL where RT can find its images.

set( $WebImagesURL, RT->config->get('WebPath') . "/NoAuth/images/" );

# $LogoURL points to the URL of the RT logo displayed in the web UI

set( $LogoURL, $Config->get('WebImagesURL') . "bplogo.gif" );

# WebNoAuthRegex - What portion of RT's URLspace should not require
# authentication.
set( $WebNoAuthRegex, qr{^ (?:/+NoAuth/ | /+REST/\d+\.\d+/NoAuth/) }x );

# For message boxes, set the entry box width, height and what type of
# wrapping to use.  These options can be overridden by users in their
# preferences.
#
# Default width: 72, height: 15
set( $MessageBoxWidth,  72 );
set( $MessageBoxHeight, 15 );

# Default wrapping: "HARD"  (choices "SOFT", "HARD")
set( $MessageBoxWrap, "HARD" );

# Support implicit links in WikiText custom fields?  A true value
# causes InterCapped or ALLCAPS words in WikiText fields to
# automatically become links to searches for those words.  If used on
# RTFM articles, it links to the RTFM article with that name.
set( $WikiImplicitLinks, 0 );

# if TrustHTMLAttachments is not defined, we will display them
# as text. This prevents malicious HTML and javascript from being
# sent in a request (although there is probably more to it than that)
set( $TrustHTMLAttachments, undef );

# Should RT redistribute correspondence that it identifies as
# machine generated? A true value will do so; setting this to '0'
# will cause no such messages to be redistributed.
# You can also use 'privileged' (the default), which will redistribute
# only to privileged users. This helps to protect against malformed
# bounces and loops caused by autoCreated requestors with bogus addresses.
set( $RedistributeAutoGeneratedMessages, 'privileged' );

# If PreferRichText is set to a true value, RT will show HTML/Rich text
# messages in preference to their plaintext alternatives. RT "scrubs" the
# html to show only a minimal subset of HTML to avoid possible contamination
# by cross-site-scripting attacks.
set( $PreferRichText, undef );

# If $WebExternalAuth is defined, RT will defer to the environment's
# REMOTE_USER variable.

set( $WebExternalAuth, undef );

# If $WebOpenIdAuth is enabled, RT will allow OpenID logins. New users who present
# OpenID Credentials will be created as unprivileged users with their OpenID as their name.
# To enable OpenID Support, you need to install LWPx::ParanoidAgent, Cache::FileCache
# and Net::OpenID::Consumer.
#
set( $WebOpenIdAuth, undef );

# If $WebFallbackToInternalAuth is undefined, the user is allowed a chance
# of fallback to the login screen, even if REMOTE_USER failed.

set( $WebFallbackToInternalAuth, undef );

# $WebExternalGecos means to match 'gecos' field as the user identity);
# useful with mod_auth_pwcheck and IIS Integrated Windows logon.

set( $WebExternalGecos, undef );

# $WebExternalAuto will create users under the same name as REMOTE_USER
# upon login, if it's missing in the Users table.

set( $WebExternalAuto, undef );

# $AutoCreate is a custom set of attributes to create the user with,
# if they are Created using $WebExternalAuto

set( $AutoCreate, undef );

# $WebSessionClass is the class you wish to use for managing Sessions.
# It defaults to use your SQL database, but if you are using MySQL 3.x and
# plans to use non-ascii Queue names, uncomment and add this line to
# RT_SiteConfig.pm will prevent session corruption.

# set($WebSessionClass , 'Apache::Session::File');

# By default, RT hold session unless user close browser application, with
# $AutoLogoff option you can setup session lifetime in minutes. User
# would be logged out if he doesn't send any requests to RT for the
# defined time.

set( $AutoLogoff, 0 );

# By default, RT's session cookie isn't marked as "secure" Some web browsers
# will treat secure cookies more carefully than non-secure ones, being careful
# not to write them to disk, only send them over an SSL secured connection
# and so on. To enable this behaviour, set # $WebSecureCookies to a true value.
# NOTE: You probably don't want to turn this on _unless_ users are only connecting
# via SSL encrypted HTTP connections.

set( $WebSecureCookies, 0 );

# By default, RT clears its database cache after every page view.
# This ensures that you've always got the most current information
# when working in a multi-process (mod_perl or FastCGI) Environment
# setting $WebFlushDbCacheEveryRequest to '0' will turn this off,
# which will speed RT up a bit, at the expense of a tiny bit of data
# accuracy.

set( $WebFlushDbCacheEveryRequest, '1' );

# $MaxInlineBody is the maximum attachment size that we want to see
# inline when viewing a transaction.  RT will inline any text if value
# is undefined or 0.  This option can be overridden by users in their
# preferences.

set( $MaxInlineBody, 12000 );

# $DefaultSummaryRows is default number of rows displayed in for search
# results on the frontpage.

set( $DefaultSummaryRows, 10 );

# By default, RT shows newest transactions at the bottom of the ticket
# history page, if you want see them at the top set this to '0'.  This
# option can be overridden by users in their preferences.

set( $OldestTransactionsFirst, '1' );

# By default, RT shows images attached to incoming (and outgoing) ticket updates
# inline. set this variable to 0 if you'd like to disable that behaviour

set( $ShowTransactionImages, 1 );

# $HomepageComponents is an arrayref of allowed components on a user's
# customized homepage ("RT at a glance").

set($HomepageComponents,
    [   qw(QuickCreate Quicksearch MyAdminQueues MySupportQueues MyReminders  RefreshHomepage)
    ]
);

# @MasonParameters is the list of parameters for the constructor of
# HTML::Mason's Apache or CGI Handler.  This is normally only useful
# for debugging, eg. profiling individual components with:
#     use MasonX::Profiler; # available on CPAN
#     @MasonParameters = (preamble => 'my $p = MasonX::Profiler->new($m, $r);');

set( @MasonParameters, () );

# $DefaultSearchResultFormat is the default format for RT search results
set($DefaultSearchResultFormat, qq{
   '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__id__</a></B>/TITLE:#',
   '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
   Status,
   Queuename, 
   Ownername, 
   Priority, 
   '__NEWLINE__',
   '', 
   '<small>__Requestors__</small>',
   '<small>__CreatedRelative__</small>',
   '<small>__ToldRelative__</small>',
   '<small>__LastUpdatedRelative__</small>',
   '<small>__time_left__</small>'}
);

# If $SuppressInlineTextFiles is set to a true value, then uploaded
# text files (text-type attachments with file names) are prevented
# from being displayed in-line when viewing a ticket's history.

set( $SuppressInlineTextFiles, undef );

# If $DontSearchFileAttachments is set to a true value, then uploaded
# files (attachments with file names) are not searched during full-content
# ticket searches.

set( $DontSearchFileAttachments, undef );

# The GD module (which RT uses for graphs) uses a builtin font that doesn't
# have full Unicode support. You can use a particular TrueType font by setting
# $ChartFont to the absolute path of that font. Your GD library must have
# support for TrueType fonts to use this option.

set( $ChartFont, undef );

# MakeClicky detects various formats of data in headers and email
# messages, and extends them with supporting links.  By default, RT
# provides two formats:
#
# * 'httpurl': detects http:// and https:// URLs and adds '[Open URL]'
#   link after the URL.
#
# * 'httpurl_overwrite': also detects URLs as 'httpurl' format, but
#   replace URL with link and *adds spaces* into text if it's longer
#   then 30 chars. This allow browser to wrap long URLs and avoid
#   horizontal scrolling.
#
# See html/Elements/MakeClicky for documentation on how to add your own.
set( @Active_MakeClicky, qw() );

# }}}

# {{{ RT UTF-8 settings

# An array that contains Languages supported by RT's internationalization
# interface.  Defaults to all *.po lexicons; setting it to qw(en ja) will make
# RT bilingual instead of multilingual, but will save some memory.

set( @LexiconLanguages, qw(*) );

# An array that contains default encodings used to guess which charset
# an attachment uses if not specified.  Must be recognized by
# Encode::Guess.

set( @EmailInputEncodings, qw(utf-8 iso-8859-1 us-ascii) );

# The charset for localized email.  Must be recognized by Encode.

set( $EmailOutputEncoding, 'utf-8' );

# }}}

# {{{ RT Date Handling Options

# You can choose date and time format.  See "Output formatters"
# section in perldoc lib/RT/Date.pm for more options.  This option can
# be overridden by users in their preferences.
# Some examples:
#set($DateTimeFormat, { Format => 'ISO', Seconds => 0 });
#set($DateTimeFormat, 'RFC2822');
#set($DateTimeFormat, { Format => 'RFC2822', Seconds => 0, DayOfWeek => 0 });
set( $DateTimeFormat, 'DefaultFormat' );

# Next two options are for Time::ParseDate
# set this to 1 if your local date convention looks like "dd/mm/yy"
# instead of "mm/dd/yy".

set( $DateDayBeforeMonth, 1 );

# Should "Tuesday" default to meaning "Next Tuesday" or "Last Tuesday"?
# set to 0 for "Next" or 1 for "Last".

set( $AmbiguousDayInPast, 1 );

# }}}

# {{{ Miscellaneous RT settings

# You can define new statuses and even reorder existing statuses here.
# WARNING. DO NOT DELETE ANY OF THE DEFAULT STATUSES. If you do, RT
# will break horribly. The statuses you add must be no longer than
# 10 characters.

set( @ActiveStatus,   qw(new open stalled) );
set( @InactiveStatus, qw(resolved rejected deleted) );

# RT-3.4 backward compatibility setting. Add/Delete Link used to record one
# transaction and run one scrip. set this value to 1 if you want
# only one of the link transactions to have scrips run.
set( $LinkTransactionsRun1Scrip, 0 );

# When this feature is enabled an user need ModifyTicket right on both
# tickets to link them together, otherwise he can have right on any of
# two.
set( $StrictLinkACL, 1 );

# set $PreviewScripMessages to 1 if the scrips preview on the ticket
# reply page should include the content of the messages to be sent.

# set $Usetransaction_batch to 1 to execute transactions in batches,
# such that a resolve and comment (for example) would happen
# simultaneously, instead of as two transactions, unaware of each
# others' existence.

# set @custom_field_valuesSources to a list of class names which extend
# RT::Model::CustomFieldValueCollection::External.  This can be used to pull lists of
# custom field values from external sources at runtime.

# }}}

# {{{ Development Mode
#
# RT comes with a "Development mode" setting.
# This setting, as a convenience for developers, turns on
# all sorts of development options that you most likely don't want in
# production:
#
# * Turns off Mason's 'static_source' directive. By default, you can't
#   edit RT's web ui components on the fly and have RT magically pick up
#   your changes. (It's a big performance hit)
#
#  * More to come
#

set( $DevelMode, '0' );

# }}}

# {{{ Deprecated options

# $AlwaysUseBase64 - Encode blobs as base64 in DB (?)
# $Ticketbase_uri - Base URI to tickets in this system; used when loading (?)
# $UseCodeTickets - This option is exists for backwards compatibility.  Don't use it.

# }}}

1;
