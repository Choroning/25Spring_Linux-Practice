#!/bin/bash
# @file    Lab_comments_advanced.sh
# @brief   Demonstrate the concept of a self-deleting script (#!/bin/rm)
# @author  Cheolwon Park
# @date    2025-05-20
#
# CONCEPT DEMONSTRATION ONLY - This version does NOT self-delete.
#
# The original script used #!/bin/rm as the shebang, which causes
# the 'rm' command to be used as the interpreter. When executed,
# the script file itself gets deleted instead of being interpreted.
#
# Original (DANGEROUS - do not use):
#   #!/bin/rm
#   WHATEVER=65
#   echo "This line is not printed."
#   exit $WHATEVER
#
# How it works:
#   1. The kernel reads the shebang and runs: /bin/rm <script-path>
#   2. The script file is deleted
#   3. No bash commands are ever executed
#
# This demonstrates that the shebang determines the interpreter,
# and any program (even rm) can be placed there.

echo "This script demonstrates the #!/bin/rm concept safely."
echo "If the shebang were #!/bin/rm, this file would delete itself on execution."
echo "The script file would be removed, and none of these echo commands would run."
