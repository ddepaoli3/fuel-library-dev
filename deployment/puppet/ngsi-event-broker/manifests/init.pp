# Put the library: ngsi_event_broker_xifi.so into this folder: /usr/local/nagios/lib/ 

# This is the row that has to be added in the nagios.cfg file. You can put it also at the end.

# broker_module=/usr/local/nagios/lib/ngsi_event_broker_xifi.so -r Trento -u http://127.0.0.1:1337

# where the fields are:

# broker_module=/usr/local/nagios/lib/ngsi_event_broker_xifi.so -r <regionID> -u http://<ngsi_adapterIP:PORT>

# Then restart the nagios.
