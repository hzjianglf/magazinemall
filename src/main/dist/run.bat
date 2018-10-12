@echo off

java -Dspring.application.admin.enabled=true -jar -Dloader.main=net.nicoll.boot.daemon.StartSpringBootService @dist.jar@ @dist.start.class@
