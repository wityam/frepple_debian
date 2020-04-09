# Bring the server up to date
sudo apt-get -y -q update
sudo apt-get -y -q upgrade

# Install PostgreSQL
# For a production installation you'll need to tune the database
# configuration to match the available hardware.
sudo apt-get -y install postgresql
sudo su - postgres
psql template1 -c "create user frepple with password 'frepple'"
psql template1 -c "create database frepple encoding 'utf-8' owner frepple"
psql template1 -c "create database scenario1 encoding 'utf-8' owner frepple"
psql template1 -c "create database scenario2 encoding 'utf-8' owner frepple"
psql template1 -c "create database scenario3 encoding 'utf-8' owner frepple"
exit
# The default frePPLe configuration uses md5 authentication on unix domain
# sockets to communicate with the PostgreSQL database.
sudo sed -i 's/local\(\s*\)all\(\s*\)all\(\s*\)peer/local\1all\2all\3\md5/g' /etc/postgresql/*/main/pg_hba.conf
sudo service postgresql restart

# Install python3 and required python modules
sudo apt-get -y install python3 python3-pip
sudo -H pip3 install -r https://raw.githubusercontent.com/frepple/frepple/6.0.0/requirements.txt

# Install the frePPLe binary .deb package and the necessary dependencies.
# There are frepple, frepple-doc and frepple-dev debian package files.
# Normally you only need to install the frepple debian package.
sudo dpkg -i frepple_*.deb
sudo apt-get -f -y -q install

# Configure apache web server
sudo a2enmod expires
sudo a2enmod wsgi
sudo a2enmod ssl
sudo a2enmod proxy             # Only Enterprise Edition
sudo a2enmod proxy_wstunnel    # Only Enterprise Edition
sudo a2ensite default-ssl
sudo a2ensite frepple
sudo service apache2 restart

# Create frepple database schema
sudo frepplectl migrate --noinput
