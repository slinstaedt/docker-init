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
		eval "$LINE" | tee $INIT_FILE || CODE=$?
		test -n "${CODE+x}" && echo "FAILED command $COUNT. Exiting." && rm $INIT_FILE && exit $CODE
	fi
	COUNT=$((COUNT+1))
done

echo "FINISHED all $COUNT commands. Exiting."
