 modphperl allows you to embed perl scripts in web-pages in the style of PHP

## INSTALL

    # example for openSUSE
    zypper install apache2-prefork apache2-mod_perl
    a2enmod perl
    mkdir -p /srv/www/perl-lib/modphperl/
    cp -a handler.pm /srv/www/perl-lib/modphperl/
    cp -a test.perl /srv/www/htdocs/
    edit /etc/apache2/default-server.conf # or /etc/apache2/vhosts.d/foo.conf to add
        AddHandler perl-script .perl
        # or SetHandler perl-script to handle all file extensions
        PerlHandler modphperl::handler

    service apache2 restart
    curl localhost/test.perl
