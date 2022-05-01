#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use Scalar::Util qw(looks_like_number);
use Term::ANSIColor;

$| = 1;  # flush every print, not on newlines

my $baseline = 0;
my $increment = 0;

if (@ARGV == 2)  {
    $baseline = $ARGV[0];
    $increment = $ARGV[1];
} elsif (@ARGV == 1)  {
    $baseline = $ARGV[0];
} elsif (@ARGV == 1 && $ARGV[0] eq "-h") {
    # TODO ask for values
    print "Usage: tea-timer.pl [BASELINE [INCREMENT]]\n\nTime tea steep, with support for time increments on subsequent steeps.\n";
    exit(0);
} else {
    print "How many seconds should your tea steep? ";
    my $r = <STDIN>;
    chomp $r;
    $baseline = $r;
}

sub seconds2str {
    my $total = shift;
    my $minutes = int($total / 60);
    my $seconds = $total - $minutes;
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
    qx(notify-send "Your tea is ready!" >/dev/null 2>&1);
    qx(play -q /usr/share/sounds/freedesktop/stereo/complete.oga >/dev/null 2>&1);
}

sub countdown {
    my $time = shift;
    # hide the cursor
    clear();
    print "\e[?25l"; # hide cursor
    do  {
        my $digits = length($time + 1);
        my $timestr = seconds2str($time);
        print "\rTime remaining: " . colored(["yellow"], "$timestr   ");
        # print "\b" x $digits . "\b";
        sleep 1;
    } while (--$time > 0);
    notify();
    print "\e[?25h\n"; # show cursor again
}

my $iter = 0;
while (1) {
    countdown($baseline + $iter * $increment);
    print colored(["bright_black"], "Press q to stop\n");
    print "Last steep was " . colored(["yellow"], seconds2str($baseline + $iter * $increment)) . "\n";
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
    $iter++;
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
