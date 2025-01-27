# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: Apache-2.0
# https://github.com/AcademySoftwareFoundation/OpenImageIO

fancy_add_executable (SYSTEM_INCLUDE_DIRS
                        ${ROBINMAP_INCLUDES}
<<<<<<< HEAD
                        ${OpenCV_INCLUDES}
=======
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
                      LINK_LIBRARIES
                        OpenImageIO
                        $<TARGET_NAME_IF_EXISTS:OpenEXR::OpenEXR>
                        ${OpenCV_LIBRARIES}
                     )
