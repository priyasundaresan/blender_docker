#!/usr/bin/env python
import os

if __name__=="__main__":
    # TRY OUT -E [CYCLES, BLENDER_EEVEE, BLENDER_WORKBENCH]
    cmd = "docker run -v %s:/tmp priya-blender \
            /tmp/render" % (os.getcwd())
    code = os.system(cmd)
