#!/usr/bin/env python
#    This is a component of AXIS, a front-end for emc
#    Copyright 2004, 2005, 2006 Jeff Epler <jepler@unpythonic.net>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

import sys, os
sys.path.insert(0, "lib")
sys.path.insert(0, "setup")

if sys.hexversion < 0x2040000:
    raise SystemExit, "Python 2.4 is required for AXIS"

from glob import glob
from distutils import sysconfig
from distutils.core import setup, Extension
from togl_setup import get_togl_flags
from emc_setup import *
import distutils.command.install
from monkeypatch import *

name="axis"
version="1.4a0"
DOCDIR="share/doc/%s-%s" % (name, version)
SHAREDIR="share/%s" % (name)
LOCALEDIR="share/locale"

emcroot = os.getenv("EMCROOT", None) or find_emc_root()
if emcroot is None:
    print """\
setup.py failed to locate the root directory of your emc installation.
Determine the location of your emc installation and re-run setup.py with a
commandline like this:
    $ env EMCROOT=/usr/local/emc python setup.py install

See the README file for more information."""
    raise SystemExit, 1
emcroot = os.path.abspath(emcroot)

emc2_marker = os.path.join(emcroot, "include", "config.h")
emc2_marker2 = os.path.join(emcroot, "include", "emc2", "config.h")
is_emc2 = os.path.exists(emc2_marker) or os.path.exists(emc2_marker2)
bdi4_marker = os.path.join(emcroot, "src/include", "config.h")
is_bdi4 = os.path.exists(bdi4_marker)

minigl = Extension("minigl",
        ["extensions/minigl.c"],
        libraries = ["GL", "GLU"],
	library_dirs = ["/usr/X11R6/lib"])
hal = None

if is_emc2:
    run_installed = (os.environ.has_key("EMC_RUN_INSTALLED") \
        or os.path.exists(emc2_marker2))
    if run_installed:
        print "(run installed)"
        include_dirs = [os.path.join(emcroot, "include", "emc2")]
        library_dirs = [os.path.join(emcroot, "lib")]
    else:
        distutils.command.install.INSTALL_SCHEMES['unix_prefix']['scripts'] = \
            "%s/bin" % (emcroot)
        distutils.command.install.INSTALL_SCHEMES['unix_prefix']['platlib'] = \
            "%s/lib/python" % (emcroot)
        distutils.command.install.INSTALL_SCHEMES['unix_prefix']['data'] = \
            "%s" % (emcroot)
        include_dirs = [os.path.join(emcroot, "include")]
        library_dirs = [os.path.join(emcroot, "lib")]
    extra_link_args = ['-Wl,-rpath,%s' % library_dirs[0]]

    print "Building AXIS", version, "for EMC2 in", emcroot
    gcode = Extension("gcode", [
            "extensions/gcodemodule.cc"
        ],
        define_macros = [('AXIS_USE_EMC2', 1), ('NEW_INTERPRETER', 1)],
        include_dirs=include_dirs,
        library_dirs=library_dirs,
        extra_link_args = extra_link_args,
        libraries = ['rs274', 'nml', 'm', 'stdc++', 'GL'],
    )

    emc = Extension("emc", ["extensions/emcmodule.cc"],
        define_macros=[('DEFAULT_NMLFILE',
            '"%s/configs/sim/emc.nml"' % emcroot),
            ('AXIS_USE_EMC2', 1)],
        libraries = ["emc", "nml", "m", "stdc++", "GL"],
        include_dirs=include_dirs,
        library_dirs=library_dirs,
        extra_link_args = extra_link_args,
    )

    if os.path.exists(os.path.join(emcroot, "lib", "libemchal.so")):
        hal = Extension("hal", ["extensions/halmodule.cc"],
        libraries = ["emchal"],
        include_dirs=include_dirs,
        library_dirs=library_dirs,
        extra_link_args = extra_link_args,
    )

    os.environ['USE_SYSTEM_BWIDGET']="yes"

elif is_bdi4:
    distutils.command.install.INSTALL_SCHEMES['unix_prefix']['scripts'] = \
            "%s/plat/linux_rtai/bin" % (emcroot)
    print "Building AXIS", version, "for BDI-4 in", emcroot


    gcode = Extension("gcode", [
            "extensions/gcodemodule.cc"
        ],
        define_macros = [('AXIS_USE_BDI4', 1), ('NEW_INTERPRETER', 1)],
        include_dirs=[
            os.path.join(emcroot, "src/include"),
        ],
        library_dirs = [
            os.path.join(emcroot, "plat/linux_rtai/lib")
        ],
        libraries = ['nml', 'm', 'stdc++'],
        extra_link_args = [
            '-Wl,-rpath,%s' % os.path.join(emcroot, "plat/linux_rtai/lib"),
            os.path.join(emcroot, "src", ".tmp", "rs274.o"),
            '-lnml', '-lm', '-lstdc++'
        ]
    )

    emc = Extension("emc", ["extensions/emcmodule.cc"],
        define_macros=[('DEFAULT_NMLFILE',
            '"%s/emc.nml"' % emcroot),
            ('AXIS_USE_BDI4', 1)],
        include_dirs=[
            os.path.join(emcroot, "src/include")
        ],
        library_dirs = [
            os.path.join(emcroot, "plat/linux_rtai/lib")
        ],
        libraries = ["emc", "nml", "m", "stdc++", "GL"]
    )

else:
    emcplat = os.getenv("PLAT", find_emc_plat(emcroot))
    if emcplat is None:
        print """\
    setup.py failed to locate the (non-realtime) platform of your emc
    installation.  Determine the platform name and re-run setup.py with a
    commandline like this:
        $ env PLAT=nonrealtime python setup.py install

    If you had to specify EMCROOT, the commandline would look like
        $ env EMCROOT=/usr/local/emc PLAT=nonrealtime python setup.py install

    See the README file for more information."""
        raise SystemExit, 1
    distutils.command.install.INSTALL_SCHEMES['unix_prefix']['scripts'] = \
            "%s/emc/plat/%s/bin" % (emcroot, emcplat)
    print "Building AXIS", version, "for EMC in", emcroot
    print "Non-realtime PLAT", emcplat

    gcode = Extension("gcode", [
            "extensions/gcodemodule.cc"
        ],
        define_macros = [('NEW_INTERPRETER', 1)],
        include_dirs=[
            os.path.join(emcroot, "emc", "plat", emcplat, "include",
                 "rs274ngc_new"),
            os.path.join(emcroot, "emc", "plat", emcplat, "include"),
            os.path.join(emcroot, "rcslib", "plat", emcplat, "include")
        ],
        library_dirs = [
            os.path.join(emcroot, "emc", "plat", emcplat, "lib"),
            os.path.join(emcroot, "rcslib", "plat", emcplat, "lib")
        ],
        libraries = ['rcs', 'm', 'stdc++'],
        extra_link_args = [
            '-Wl,-rpath,%s' % 
                os.path.join(emcroot, "rcslib", "plat", emcplat, "lib"),
            os.path.join(emcroot, "emc", "plat", emcplat, "lib", "rs274abc.o"),
        ]
    )

    emc = Extension("emc", ["extensions/emcmodule.cc"],
        define_macros=[('DEFAULT_NMLFILE', '"%s/emc/emc.nml"' % emcroot)],
        include_dirs=[
            os.path.join(emcroot, "emc", "plat", emcplat, "include"),
            os.path.join(emcroot, "rcslib", "plat", emcplat, "include")
        ],
        library_dirs = [
            os.path.join(emcroot, "emc", "plat", emcplat, "lib"),
            os.path.join(emcroot, "rcslib", "plat", emcplat, "lib")
        ],
        libraries = ["emc", "rcs", "m", "stdc++", "GL"],
        extra_link_args = ['-Wl,-rpath,%s' % 
            os.path.join(emcroot, "rcslib", "plat", emcplat, "lib")]
    )

flags = get_togl_flags()
togl = Extension("_togl", ["extensions/_toglmodule.c"], **flags)
seticon = Extension("_tk_seticon", ["extensions/seticon.c"], **flags)

ext_modules = [emc, togl, gcode, minigl, seticon]
if hal:
    ext_modules.append(hal)

def lang(f):
    import os
    return os.path.splitext(os.path.basename(f))[0]
i18n = [(os.path.join(LOCALEDIR,lang(f),"LC_MESSAGES"), [(f, "axis.mo")])
            for f in glob("i18n/??.mo") + glob("i18n/??_??.mo")]

setup(name=name, version=version,
    description="AXIS front-end for emc",
    author="Jeff Epler", author_email="jepler@unpythonic.net",
    package_dir={'': 'lib', 'rs274' : 'rs274'},
    packages=['', 'rs274'],
    scripts={WINDOWED('axis'): 'scripts/axis.py',
             TERMINAL('axis-remote'): 'scripts/axis-remote.py',
             TERMINAL('emctop'): 'scripts/emctop.py',
             TERMINAL('hal_manualtoolchange'): 'scripts/hal_manualtoolchange.py',
             TERMINAL('mdi'): 'scripts/mdi.py'},
    cmdclass = { 'build_scripts': build_scripts, 'install_data': install_data},
    data_files = [(os.path.join(SHAREDIR, "tcl"), glob("tcl/*.tcl")),
                  (os.path.join(SHAREDIR, "tcl"), glob("thirdparty/*.tcl")),
                  (os.path.join(SHAREDIR, "images"), glob("images/*.gif")),
                  (os.path.join(SHAREDIR, "images"), glob("images/*.xbm")),
                  (os.path.join(SHAREDIR, "images"), ["images/axis.ngc"]),
                  (DOCDIR, ["COPYING", "README", "BUGS",
                        "doc/axis_light_background",
                        "thirdparty/LICENSE-Togl"])] + i18n,
    ext_modules = ext_modules,
    url="http://axis.unpythonic.net/",
    license="GPL",
)

# vim:ts=8:sts=4:et:
