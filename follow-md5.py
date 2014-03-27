#! /usr/bin/env python


def read_md5_file(filename):
    s = {}
    with open(filename) as f:
        for line in f:
            (hashval, filename) = line.rstrip("\r\n").split(None, 1)
            assert filename not in s
            s[filename] = hashval
    return s


def mk_diff(f1, f2):

    msgs = []

    for f in f1:
        if f not in f2:
            msgs.append(("deleted", f))

    for f in f2:
        if f not in f1:
            msgs.append(("created", f))

    for f in f2:
        if f in f1:
            if f1[f] == f2[f]:
                msgs.append(("unchanged", f))
            else:
                msgs.append(("changed", f))

    # sort in-place by verb, then by filename
    msgs.sort()

    return msgs


def main():

    filenames = [
        "build/md5_after_binutils",
        "build/md5_after_gcc_bootstrap",
        "build/md5_after_newlib",
        "build/md5_after_gcc_full",
        "build/md5_after_gdb"
    ]

    curr_filename = "<none>"
    curr_files = {}

    for next_filename in filenames:

        next_files = read_md5_file(next_filename)

        print "====================== changes between %s (%d files) to %s (%d files)." % (curr_filename, len(curr_files), next_filename, len(next_files))
        print

        for (verb, filename) in mk_diff(curr_files, next_files):
            print "%-10s: %s" % (verb, filename)

        print

        (curr_filename, curr_files) = (next_filename, next_files)


if __name__ == "__main__":
    main()
