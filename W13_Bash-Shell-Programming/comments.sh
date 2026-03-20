#!/bin/more
# @file    comments.sh
# @brief   A self-displaying script using #!/bin/more as the interpreter
# @author  Cheolwon Park
# @date    2025-05-20
#
# When executed, this script displays its own contents using 'more'.
# The shebang #!/bin/more causes the 'more' pager to be used as
# the interpreter, which simply displays the file content.
#
# This demonstrates that the shebang line determines how a script
# is processed -- any program can be used as an "interpreter".
#
# Usage:
#   chmod +x comments.sh
#   ./comments.sh
#
# The entire file (including these comments) will be displayed.

echo "This line is printed by 'more', not executed by bash."
echo "If you run this with 'bash comments.sh', these lines execute normally."
