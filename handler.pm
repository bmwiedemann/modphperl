package modphperl::handler;
use strict;
use Apache2::Const ();

# usage in apache config:
#	SetHandler perl-script
#	PerlHandler modphperl::handler

sub file_content($) {my($fn)=@_;
   open(FCONTENT, "<", $fn) or return undef;
   local $/;
   my $result=<FCONTENT>;
   close(FCONTENT);
   return $result;
}

sub handler {
	my $r = shift;
	$r->status(200);
	$r->content_type("text/html");
	my $f=$r->filename;
	if(-r $f) {
		my $page=awstandard::file_content($f);
		my $pkg=$r->uri;
		$pkg=~s/^\/+//;
		$pkg=~s/[^a-zA-Z0-9_\/]/_/g;
		$pkg=~s/\//::/g;
#		$page.=$pkg;
		{
			no strict;
			$page=~s%<\?perl ([^?]*(?:\?[^>][^?]*)*)\?>%my $x=eval("package $pkg;".$1);if($@) {$x=$@} $x %ge;
		}
		$r->print($page);
	} else {
		$r->status(404);
		$r->content_type("text/plain");
		$r->print($r->uri." not found");
	}
	return Apache2::Const::OK();
}

1;
