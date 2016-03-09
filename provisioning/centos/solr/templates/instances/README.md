# HOW TO CREATE A NEW INSTANCE

    - Clone the instance1 example

    - Make the necessary changes in instance name and core names

    - Config files to edit in each new deployment:
        /opt/solr/instances/<instance_name>.xml
        /opt/solr/instances/<instance_name>/solr.xml
        /opt/solr/instances/<instance_name>/<core_name>/schema.xml
        /opt/solr/instances/<instance_name>/<core_name>/dataimport.xml

    - To make tomcat aware of a new instance, run:
        ln -s /opt/solr/instances/<instance_name>.xml /usr/share/tomcat6/conf/Catalina/localhost/<instance_name>.xml