$inFile = $ARGV[0];
$outFile = $ARGV[1];
$varName = $ARGV[2];

open IN, "<$inFile";
open OUT, ">$outFile";

$lineNum = 0;
print OUT "public static var $varName = [\n";
while ($line = <IN>)
{
    chomp($line);
    $line =~ s/\r//g;
    if ($line ne "" && $line !~ /^#[^#].*/)
    {
	if ($line eq "##")
	{
	   print OUT ",\n\n";
	   $lineNum = 0;
	}
	else
	{
	    if ($line !~ /(>)$|(\\n)$/)
	    {
		$line = $line . " ";
	    }
	    $line =~ s/^\s*//;
	    
#	    $line =~ s/\\/\\\\/g;
	    $line =~ s/"/\\"/g;
	    $line =~ s/\t/\\t/g;
	    $line =~ s/\s+/ /g;
		   
	    if ($lineNum == 0)
	    {
		$lineNum = 1;
	    }
	    else
	    {
		print OUT "+ ";
	    }
	    print OUT "\"$line\"\n";
	}
    }
}
print OUT "];\n";
