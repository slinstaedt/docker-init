#!/bin/sh
set -euo pipefail

test ! -d $INIT_DIR && echo "ERROR: Volume '$INIT_DIR' is not mounted." && exit 1

COUNT=1
for LINE in "$@"; do
	INIT_FILE=$INIT_DIR/$COUNT.log
	if [ -f $INIT_FILE ]; then
		printf 'SKIPPING %2d: %s\n' "$COUNT" "$LINE"
	else
		printf 'RUNNING  %2d: %s\n' "$COUNT" "$LINE"
		eval "${LINE#§}" | tee $INIT_FILE || CODE=$?
		test -n "${CODE+x}" && echo "FAILED command $COUNT. Exiting." && rm $INIT_FILE && exit $CODE
		test "${LINE:0:1}" = "§" && rm $INIT_FILE
	fi
	COUNT=$((COUNT+1))
done

echo "FINISHED all $((COUNT-1)) commands. Exiting."
