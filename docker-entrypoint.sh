#!/bin/sh
set -euo pipefail

test ! -d $INIT_DIR && echo "ERROR: Volume '$INIT_DIR' is not mounted." && exit 1

COUNT=1
for LINE in "$@"; do
	INIT_FILE=$INIT_DIR/$COUNT.log
	CMD=$(test "${LINE:0:1}" = "+" && echo ${LINE:1} || echo ${LINE})
	if [ -f $INIT_FILE ]; then
		printf 'SKIPPING %2d: %s\n' "$COUNT" "$CMD"
	else
		printf 'RUNNING  %2d: %s\n' "$COUNT" "$CMD"
		eval "$CMD" | tee $INIT_FILE || CODE=$?
		test -n "${CODE+x}" && echo "FAILED command $COUNT. Exiting." && rm $INIT_FILE && exit $CODE
		test "${LINE:0:1}" = "+" && echo "Flag for rerun." && rm $INIT_FILE || true
	fi
	COUNT=$((COUNT+1))
done

echo "FINISHED all $((COUNT-1)) commands. Exiting."
