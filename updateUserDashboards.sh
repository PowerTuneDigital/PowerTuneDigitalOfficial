#!/bin/sh
echo "copy new Dashboards"
rsync -a -v /home/pi/src/exampleDash/Logo/*.png /home/pi/Logo/
rsync -a -v /home/pi/src/exampleDash/UserDashboards/*.txt /home/pi/UserDashboards/

