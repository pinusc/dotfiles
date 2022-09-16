#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use Scalar::Util qw(looks_like_number);
use Term::ANSIColor;
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
# use Text::ProgressBar::Bar;
# use Curses;

$| = 1;  # flush every print, not on newlines

my $baseline = 0;
my $increment = 0;
my $prestart = 3;
my $colorbehavior = "auto";
my $colorenabled = "auto";
my $soundenabled = 1;

GetOptions(
    "time=i" => \$baseline,
    "increment=i" => \$increment,
    "prestart:i" => \$prestart,
    "sound!" => \$soundenabled,
    "color:s" => \$colorbehavior,
    "help|?" => sub { pod2usage(-exitval => 0, -verbose => 1) },
) or pod2usage(2);

if (@ARGV == 2)  {
    $baseline = $ARGV[0];
    $increment = $ARGV[1];
} elsif (@ARGV == 1)  {
    $baseline = $ARGV[0];
}

if ($colorbehavior eq "auto") {
    $ENV{ANSI_COLORS_DISABLED} = ! -t STDOUT;
} elsif ($colorbehavior eq "always") {
    $ENV{ANSI_COLORS_DISABLED} = 0;
} elsif ($colorbehavior eq "never") {
    $ENV{ANSI_COLORS_DISABLED} = 1;
} else {
    print qq(Invalid option --color $colorbehavior. Valid options are "auto", "never", "always"\n\n);
    pod2usage(-verbose => 1, -exitval => 2);
}

unless ($baseline) {
    print "How many seconds should your tea steep? ";
    my $r = <STDIN>;
    chomp $r;
    $baseline = $r;
}


sub seconds2str {
    my $total = shift;
    my $minutes = int($total / 60);
    my $seconds = $total % 60;
    if ($minutes > 0) {
        return sprintf("%02d:%02d", $minutes, $seconds);
    } else {
        return $seconds . "s"
    }
}

sub clear {
    print "\033[2J";    #clear the screen
    print "\033[0;0H"; #jump to 0,0
}


sub notify {
    clear();
    say colored(["green"], "Time's up!");
    say "You can pu'er that tea now";
    if ($soundenabled) {
        qx(play -q /usr/share/sounds/freedesktop/stereo/complete.oga >/dev/null 2>&1);
    }
    qx(notify-send -u critical "Your tea is ready!" "You can pu'er it now" >/dev/null 2>&1);
}

sub countdown {
    my $time = shift;
    my $text = shift;
    my $elapsed = 0;
    # my $progress = Text::ProgressBar->new(maxval => $time);
    # $progress::maxval = $time;
    # $progress->start();
    # hide the cursor
    clear();
    print "\e[?25l"; # hide cursor
    do  {
        my $digits = length($time - $elapsed + 1);
        my $timestr = seconds2str($time - $elapsed);
        print "\r$text" . colored(["yellow"], "$timestr   ");
        # $progress->update($elapsed);
        # print "\b" x $digits . "\b";
        sleep 1;
    } while (++$elapsed < $time);
    # $progress->finish();
    print "\e[?25h\n"; # show cursor again
}

# timer is a countdown with final alert
sub timer {
    countdown @_;
    notify();
}


my $timeval = $baseline;
while (1) {
    if ($prestart) {
        countdown($prestart, "Starting in... ");
    }
    timer($timeval, "Time remaining: ");
    print colored(["bright_black"], "Press q to stop\n");
    print "Last steep was " . colored(["yellow"], seconds2str($timeval)) . "\n";
    print "Increment for next steep? [" . colored(["green"], $increment) . "]:  " . color("green");
    my $r = <STDIN>;
    chomp $r;
    print color("reset");
    # if $s is empty, keep current increment
    if (looks_like_number($r)) {
        $increment = $r;
        say "Increment is $increment now";
    } elsif (!$r eq "") {
        last ;
    }
    $timeval += $increment;
}

use sigtrap 'handler' => \&sigtrap, 'HUP', 'INT','ABRT','QUIT','TERM';
sub sigtrap(){
    print "\e[?25h\n";
    print color("reset");
    print "Interrupted! Make sure not to oversteep :)\n";
    exit(1);
}


# use Desktop::Notify;

# # Open a connection to the notification daemon
# my $notify = Desktop::Notify->new();

# # Create a notification to display
# my $notification = $notify->create(summary => 'Desktop::Notify',
#                                    body => 'Hello, world!',
#                                    timeout => 5000);

# # Display the notification
# $notification->show();
 
__END__

=head1 NAME

tea-timer.pl - A simple terminal gongfu tea timer 

=head1 SYNOPSIS

tea-timer.pl [options] [TIME [INCREMENT]]

=head1 OPTIONS

=over 4

=item B<TIME>

Length of time, in seconds, the timer should count. 
If not given as an argument, it will be prompted on screen.
If B<INCREMENT> is non-zero, ...

=item B<--prestart|-p>[=VALUE]

By default, tea-timer.pl starts a 3s timer before the actual countdown, to give
some time to actually pour water and start steeping.
If --prestart is passed without arguments, this behavior is turned off.
If VALUE is given, set the pre-start timer to VALUE seconds. 

=item B<--color>[=VALUE]

If VALUE is "auto", colorize output only if the output device is a terminal, and print uncolorized output if it is a pipe, file, or otherwise.
If VALUE is "never", always produce uncolorized output.
If VALUE is "always", always produce colorized output.

The default behavior is "auto".

=item B<--no-sound>

Disable playing a sound notification.

=back

=cut
