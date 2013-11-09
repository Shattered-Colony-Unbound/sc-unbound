$inFile = $ARGV[0];
$outFile = $ARGV[1];

open IN, "<$inFile";
open OUT, ">$outFile";

$isFunction = 0;
$lineNum = 0;
while ($line = <IN>)
{
    chomp($line);
    $line =~ s/\r//g;
    if ($line ne "" && $line !~ /^#[^#].*/)
    {
	if ($lineNum == 0)
	{
	    if ($line =~ /!([0-9]+) ([a-zA-Z0-9]+)$/)
	    {
		$isFunction = 1;
		$count = $1;
		$name = $2;
		print OUT "public static function $name(";
		for ($i = 0; $i < $count; ++$i)
		{
		    print OUT "a$i : String";
		    if ($i < $count - 1)
		    {
			print OUT ", ";
		    }
		}
		print OUT ") : String\n{\nreturn ";
	    }
	    else
	    {
		$isFunction = 0;
		print OUT "public static var $line = \n";
	    }
	    $lineNum = 1;
	}
	elsif ($line eq "##")
	{
	    if ($isFunction == 0)
	    {
		print OUT ";\n\n";
	    }
	    else
	    {
		print OUT ";\n}\n\n";
	    }
	    $lineNum = 0;
	}
	else
	{
	    if ($line !~ /(>)|(\\n)$/)
	    {
		$line = $line . " ";
	    }
	    $line =~ s/^\s*//;
	    
#	    $line =~ s/\\/\\\\/g;
	    $line =~ s/"/\\"/g;
	    $line =~ s/\t/\\t/g;
	    $line =~ s/\s+/ /g;
	    $line =~ s/\$([0-9]+)/"+a$1+"/g;
	    $line =~ s/\$\$/\$/g;
		   
	    if ($lineNum == 1)
	    {
		$lineNum = 2;
	    }
	    else
	    {
		print OUT "+ ";
	    }
	    print OUT "\"$line\"\n";
	}
    }
}
print OUT ";\n";
if ($isFunction)
{
    print OUT "}\n\n";
}
