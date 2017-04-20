-- Import data to pt
COPY pt FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/pt60.csv'
 DELIMITER ',' CSV HEADER;

-- Import Data to IP Invoices

COPY ip_inv FROM '/Volumes/Macintosh HD/Users/sksy/git/PyPym/Data/IPinv.csv'
 DELIMITER ',' CSV HEADER;