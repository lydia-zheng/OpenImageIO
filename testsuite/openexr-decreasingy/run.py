#!/usr/bin/env python

# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: Apache-2.0
# https://github.com/AcademySoftwareFoundation/OpenImageIO

import os, sys

####################################################################
# Verify decreasingY line order generates same image as increasingY (default).
####################################################################

# Capture error output
redirect = " >> out.txt 2>&1 "

# Create reference images stored in increasingY order (default)
# Resizing to a large image size to ensure scanline chunking logic is triggered.
<<<<<<< HEAD
command += oiiotool("../common/tahoe-tiny.tif --resize 4080x3072 -o increasingY-resize.exr")
command += info_command("increasingY-resize.exr", safematch=True, hash=False)
command += oiiotool("increasingY-resize.exr -o increasingY-copy.exr")
command += info_command("increasingY-copy.exr", safematch=True, hash=False)

# Create an image in decreasing order via resizing (Tests ImageOutput::write_image() logic)
command += oiiotool("../common/tahoe-tiny.tif --resize 4080x3072 --attrib openexr:lineOrder decreasingY -o decreasingY-resize.exr")
command += info_command("decreasingY-resize.exr", safematch=True, hash=False)

# Create an image in decreasing order via copying a reference image. (Tests ImageBuf::write() logic)
command += oiiotool("decreasingY-resize.exr --attrib openexr:lineOrder decreasingY -o decreasingY-copy.exr")
command += info_command("decreasingY-copy.exr", safematch=True, hash=False)

# They should match
command += diff_command("increasingY-copy.exr", "decreasingY-copy.exr")
command += diff_command("increasingY-resize.exr", "decreasingY-resize.exr")
=======
command += oiiotool("../common/tahoe-tiny.tif --resize 4080x3072 -o ref/decreasingY-resize.exr")
command += info_command("ref/decreasingY-resize.exr")
command += oiiotool("ref/decreasingY-resize.exr -o ref/decreasingY-copy.exr")
command += info_command("ref/decreasingY-copy.exr")

# Create an image in decreasing order via resizing (Tests ImageOutput::write_image() logic)
command += oiiotool("../common/tahoe-tiny.tif --resize 4080x3072 --attrib openexr:lineOrder decreasingY -o decreasingY-resize.exr")
command += info_command("decreasingY-resize.exr")

# Create an image in decreasing order via copying a reference image. (Tests ImageBuf::write() logic)
command += oiiotool("ref/decreasingY-resize.exr --attrib openexr:lineOrder decreasingY -o decreasingY-copy.exr")
command += info_command("decreasingY-copy.exr")
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a

# Outputs to check against references.
# This makes sure the images look the same since the line order is a storage detail and should not
# change how the image actually looks. These comparisons help verify chunk order and scanlines are
# processed properly.
outputs = [
<<<<<<< HEAD
    "out.txt"
]


#print "Running this command:\n" + command + "\n"
=======
    "decreasingY-resize.exr",
    "decreasingY-copy.exr",
]


#print "Running this command:\n" + command + "\n"
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
