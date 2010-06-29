#!/bin/bash

$1 $2/input.txt < $2/move > output/$2.output
diff output/$2.output $2/output.txt >> results.txt

exit 0
