#!/usr/bin/perl
use strict;
use warnings;

my $file = "Orthogroups.GeneCount.csv";
open R, $file;
my @lines = <R>;
close R;
chomp @lines;
my $title = shift @lines;

my $gene_file = "Orthogroups.txt";
open R, $gene_file;
my @gene_lines = <R>;
close R;
chomp @gene_lines;

my %group2isolate;
my %group2dicot;
my %group2monocot;
my %gene2group;
my %group2gene;
my %group2total;
my %group2conserve;
my %group2line;
my %group2count;
my @isolates = qw /Bgh2 BghR1 Bgt Ene UCSC1 UMSG1 UMSG2 UMSG3/;

foreach my $line (@gene_lines){
	my @eles = split /\: /,$line;
	my $group = $eles[0];
	my @genes = split / /, $eles[1];
	my $total = scalar @genes;
	$group2count{$group}=$total;
	foreach my $gene (@genes){
		$group2gene{$group}{$gene}++;
		$gene2group{$gene}=$group;
		my ($iso,$name)=split /\|/,$gene;
		$group2isolate{$group}{$iso}{$gene}++;
	}	
	if ($total ==1){
		$group2conserve{$group}="singleton";
		$group2line{$group}="$group\t1\t0\t0\t0\t0\t0\t0\t0\t$total\t1" if $group2isolate{$group}{Bgh2};
		$group2line{$group}="$group\t0\t1\t0\t0\t0\t0\t0\t0\t$total\t1" if $group2isolate{$group}{BghR1};
		$group2line{$group}="$group\t0\t0\t1\t0\t0\t0\t0\t0\t$total\t1" if $group2isolate{$group}{Bgt};
		$group2line{$group}="$group\t0\t0\t0\t1\t0\t0\t0\t0\t$total\t1" if $group2isolate{$group}{Ene};
		$group2line{$group}="$group\t0\t0\t0\t0\t1\t0\t0\t0\t$total\t1" if $group2isolate{$group}{UCSC1};
		$group2line{$group}="$group\t0\t0\t0\t0\t0\t1\t0\t0\t$total\t1" if $group2isolate{$group}{UMSG1};
		$group2line{$group}="$group\t0\t0\t0\t0\t0\t0\t1\t0\t$total\t1" if $group2isolate{$group}{UMSG2};
		$group2line{$group}="$group\t0\t0\t0\t0\t0\t0\t0\t1\t$total\t1" if $group2isolate{$group}{UMSG3};
	}
	#if ($total <4){
#	my $printline = join ",", @genes;
#	print $line, "\n"; print $total, "\n";
#	print $group, ","; print  "$printline\n\n";sleep 1;
#	}

}



foreach my $line (@lines){
	$line =~ s/\r//g;
	chomp $line;
	my ($group,$Bgh,$BghR,$Bgt,$Ene,$UCSC1,$UMSG1,$UMSG2,$UMSG3,$total)=split /\t/,$line;
	print $line, "\n" if $total != $group2count{$group};
#	my $new_line = "$group\t$Bgh\t$BghR\t$Bgt\t$Ene\t$UCSC1\t$UMSG1\t$UMSG2\t$UMSG3\t$total";
	my $conserve = "NA";
	my $isolate_num = 0;
	$isolate_num ++ if $Bgh>0; $isolate_num ++ if $BghR>0; $isolate_num ++ if $Bgt>0; $isolate_num ++ if $Ene>0;
	$isolate_num ++ if $UCSC1>0; $isolate_num ++ if $UMSG1>0; $isolate_num ++ if $UMSG2>0; $isolate_num ++ if $UMSG3>0;
	my $new_line = "$group\t$Bgh\t$BghR\t$Bgt\t$Ene\t$UCSC1\t$UMSG1\t$UMSG2\t$UMSG3\t$total\t$isolate_num";
	if ($Bgh>0 && $BghR>0 && $Bgt>0 && $Ene>0 && $UCSC1>0 && $UMSG1>0 && $UMSG2>0 && $UMSG3>0 && $total ==8){
		$conserve = "Core-1";
	}
	elsif ($Bgh>0 && $BghR>0 && $Bgt>0 && $Ene>0 && $UCSC1>0 && $UMSG1>0 && $UMSG2>0 && $UMSG3>0 && $total >8){
                $conserve = "Core-M";
        }
	elsif ($isolate_num==7){
		$conserve = "L-Core";
	}
	
	my $dicot_num =0; 
	$dicot_num ++ if $Ene>0; $dicot_num ++ if $UCSC1>0;$dicot_num ++ if $UMSG1>0;$dicot_num ++ if $UMSG2>0;$dicot_num ++ if $UMSG3>0;
	my $monocot_num =0;
        $monocot_num ++ if $Bgh>0; $monocot_num ++ if $BghR>0;$monocot_num ++ if $Bgt>0;
	if ($dicot_num >1 && $monocot_num ==0){
		$conserve = "LS-D"
	}
	if ($dicot_num ==0 && $monocot_num >1){
                $conserve = "LS-M"
        }
	if ($dicot_num >0 && $monocot_num >0 && $isolate_num <=6 && $isolate_num>1){
		$conserve = "Other";
	}
	if ($isolate_num==1 && $total >1){
		$conserve = "BS";
	}
	if ($isolate_num==1 && $total ==1) {
		$conserve = "singleton";
	}
	$group2conserve{$group}= $conserve;
	$group2line{$group}=$new_line;
#	print "$group,$conserve,$Bgh,$BghR,$Bgt,$Ene,$UCSC1,$UMSG1,$UMSG2,$UMSG3\n";sleep 2;
	print $line,"\n" if $conserve eq "NA";
#	if ($line =~ /(OG\d+?)\t(.*)/){
#		print $line, "\n";
#		my $group = $1;
#		my $genes = $2;
#		print $group ,"\n"; print $genes, "\n";sleep 2;
#		$group2total{$group} =$genes;
#		my @eles = split / /,$genes;
#	}
}

open W, ">Orthogroup_conserve_cutsp.tab";
print W "orthogroup\tconservation\tgroup\tBgh\tBghR\tBgt\tEne\tUCSC1\tUMSG1\tUMSG2\tUMSG3\ttotal\tisolate\tmembers\n";
foreach my $group (sort {$a cmp $b} keys %group2conserve){
	my $conserve = $group2conserve{$group};
	my $line = $group2line{$group};
#	print $group, "\n" if !$group2line{$group}; #sleep 1;
	my $genes = join ",",sort {$a cmp $b} keys %{$group2gene{$group}};
	#print "$group, $conserve, $line\n"; sleep 1;
	print W "$group\t$conserve\t$line\t$genes\n";
}
close W;

my $Bgh2_out = "Bgh2_orthogroup.tab"; my $BghR1_out = "BghR1_orthogroup.tab";my $Bgt_out = "Bgt_orthogroup.tab";my $Ene_out = "Ene_orthogroup.tab";
my $UCSC1_out = "UCSC1_orthogroup.tab";my $UMSG1_out = "UMSG1_orthogroup.tab";my $UMSG2_out = "UMSG2_orthogroup.tab";my $UMSG3_out = "UMSG3_orthogroup.tab";

foreach my $isolate (@isolates){
	open W, ">$isolate\_orthogroup_cutsp.tab";
	print W "gene\torthogroup\tconservation\tgroup\tBgh\tBghR\tBgt\tEne\tUCSC1\tUMSG1\tUMSG2\tUMSG3\ttotal\tisolate\tmembers\n";
	close W;
}

foreach my $gene (sort {$a cmp $b} keys %gene2group){
	my ($isolate,undef)=split /\|/,$gene;
	my $group = $gene2group{$gene};
	my $line = $group2line{$group};
	my $conserve = $group2conserve{$group};
	my $genes = join ",",sort {$a cmp $b} keys %{$group2gene{$group}};
	open W, ">>$isolate\_orthogroup_cutsp.tab";
	print W "$gene\t$group\t$conserve\t$line\t$genes\n";
	close W;
}
















