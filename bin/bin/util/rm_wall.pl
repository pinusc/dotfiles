#!/usr/bin/env perl

use strict;
use warnings;
use Text::ParseWords;
use Term::ReadKey;



open(my $in, "<", "/home/pinusc/.fehbg") or die 'can not open ~/.fehbg: $!';

while (my $line = <$in>) {
    if ($line =~ /^[\S]*feh/) {
        my @args = grep(!/^-/, shellwords($line));
        @args = @args[1..@args];
        # now we check the nth one...
        print "ARGV\n";
        my $n = 0;
        if (@ARGV == 1) {
            $n = @ARGV[0] - 1;
        }         print "Background image is: $args[$n]\n";
        print "Preview? [y/n] ";
        ReadMode 'raw';
        my $res = ReadKey 0;
        print "\n";
        if ($res eq "y") {
            `sxiv "$args[$n]"`
        }
        print "Delete? [y/n] ";
        $res = ReadKey 0;
        if ($res eq "y") {
            `rm "$args[$n]"`
        }
        print "\n";
        ReadMode 'restore';
    }
}
