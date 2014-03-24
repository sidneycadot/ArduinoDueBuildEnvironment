#! /usr/bin/env python

def read_md5(filename):
    s = {}
    with open(filename) as f:
        for line in f:
            (hashval, filename) = line.rstrip("\r\n").split(None, 1)
            assert filename not in s
            s[filename] = hashval
    return s

def mkdiff(f1, f2):

    msgs = []

    for f in f1:
        if f not in f2:
            msgs.append(("DELETED", f))
    for f in f2:
        if f not in f1:
            msgs.append(("CREATED", f))
    for f in f2:
        if f in f1:
            if f1[f] == f2[f]:
                msgs.append(("UNCHANGED", f))
            else:
                msgs.append(("CHANGED", f))

    msgs.sort()

    return msgs

def main():

    filenames = [
        "md5_after_binutils",
        "md5_after_gcc_bootstrap",
        "md5_after_newlib",
        "md5_after_gcc_full",
        "md5_after_gdb"
    ]

    curr_filename = "<none>"
    curr_files = {}


    for next_filename in filenames:

        next_files = read_md5(next_filename)

        print "====================== changes between %s (%d files) to %s (%d files)." % (curr_filename, len(curr_files), next_filename, len(next_files))

        for (verb, filename) in mkdiff(curr_files, next_files):
            print "    %s: %s" % (verb, filename)

        (curr_filename, curr_files) = (next_filename, next_files)

if __name__ == "__main__":
    main()
