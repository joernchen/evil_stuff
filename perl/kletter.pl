#!/usr/bin/perl -w
# This script is intended to run recursively through ENUM domains.
# if you don't know what this means then you better not use it.
# To use this script start it with "perl kletter.pl X.X.X.e164.arpa"
# where X.X.X ist the ENUM Block you want to scan.
use Net::DNS;

sub query_next{
        my $domain  = $_[0];
        my $res   = Net::DNS::Resolver->new;
        foreach (0..9){
                my $query = $res->send("$_.".$domain,"NAPTR");
                if ($query){
                                        my $arrname;
                                        my $rrname;
                                        foreach my $arr ($query->authority) {
                                                $arrname=$arr->name;
                                        }
                                foreach my $rr ($query->answer) {
                                        print $rr->string,"\n";
                                        $rrname=$rr->name;
                                }
                                $rrname = $arrname unless $rrname;
                                if ($query->header->rcode eq "NOERROR" && length($rrname) <= length($arrname)){
                                        query_next($_.".".$domain);
                                }
                }
        }
}

query_next($ARGV[0]);

