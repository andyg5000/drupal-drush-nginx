server {
        server_name servername.local;
        root absolutepath;
 
        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }
 
        location ~ \..*/.*\.php$ {
                return 403;
        }
 
        location / {
                # This is cool because no php is touched for static content
                try_files $uri @rewrite;
        }
 
        location @rewrite {
                # Some modules enforce no slash (/) at the end of the URL
                # Else this rewrite block wouldn't be needed (GlobalRedirect)
                rewrite ^/(.*)$ /index.php?q=$1;
        }
 
        location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_intercept_errors on;
                fastcgi_pass unix:/tmp/php-fpm.sock;
        }
 
        # Fighting with ImageCache? This little gem is amazing.
        location ~ ^/sites/.*/files/imagecache/ {
                try_files $uri @rewrite;
        }

        # Catch image styles for D7 too.
        location ~ ^/sites/.*/files/styles/ {
                try_files $uri @rewrite;
        }
 
        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }
}
