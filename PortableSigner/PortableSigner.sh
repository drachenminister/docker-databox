#!/bin/sh
PROGDIR=/opt/PortableSigner/
IFS='
'
exec java -cp $PROGDIR -jar $PROGDIR/PortableSigner.jar $*
