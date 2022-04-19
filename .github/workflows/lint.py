import os
import subprocess
import sys

print("Python {}.{}.{}".format(*sys.version_info))  # Python 3.8
with open("git_diff.txt") as in_file:
    modified_files = sorted(in_file.read().splitlines())
print("{} files were modified.".format(len(modified_files)))

# Remove files that do not exist from the list.
modified_files = [file for file in modified_files if os.path.isfile(file)]

cpp_exts = tuple(".c .c++ .cc .cpp .cu .cuh .cxx .h .h++ .hh .hpp .hxx".split())
cpp_files = [file for file in modified_files if file.lower().endswith(cpp_exts)]
print(f"{len(cpp_files)} C++ files were modified.")
if not cpp_files:
    sys.exit(0)



print("cpplint:")

# Run the lint command, capture the output and return code.
# The return code will be non-zero if there are errors.
args = ["cpplint"]
args.extend(["--linelength=120", "--filter=-legal/copyright,-whitespace/braces", "--output=vs7", "--counting=toplevel"])
args.extend(cpp_files)
print(" ".join(args))
result = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# Get the first 10 lines of the stderr output.
# This is the output from cpplint.
output = result.stderr.decode("utf-8")
output = "\n".join(output.splitlines()[:10])

# Save the output to a file.
with open("cpplint.txt", "w") as out_file:
    # Write the first 10 lines of stderr to the file.
    out_file.write("Here are the first 10 encountered errors:\n`")
    out_file.write(output)

    out_file.write("\n`\n")
    out_file.write(result.stdout.decode("utf-8"))
