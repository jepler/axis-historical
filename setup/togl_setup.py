import commands
import _tkinter
import os

def add(l, c):
    if c in l: return
    l.append(c)

def add_if_exists(l, c):
    c = os.path.abspath(c)
    if c.startswith("/lib"): return
    if c in l: return
    if not os.path.exists(c): return
    l.append(c)

def get_togl_flags():

    libs = ['X11', 'GL', 'GLU', 'Xmu']
    lib_dirs = []
    include_dirs = []

    tcl_library = None
    tk_library = None
    lddinfo = commands.getoutput("ldd %s" % _tkinter.__file__)
    tkinterlibs = [line.strip().split(" => ") for line in lddinfo.split("\n")]
    for l, m in tkinterlibs:
        m = m.split("(")[0].strip()
        add_if_exists(lib_dirs, os.path.join(m, ".."))
        if l.startswith("lib"): l = l[3:]
        if l.startswith("tcl"):
            tcl_library = os.path.splitext(l)[0]
            add_if_exists(include_dirs, os.path.join(m, "..", "..", "include", l))
            add_if_exists(include_dirs, os.path.join(m, "..", "..", "include"))
        if l.startswith("tk"):
            tk_library = os.path.splitext(l)[0]
            add_if_exists(include_dirs, os.path.join(m, "..", "..", "include", l))
            add_if_exists(include_dirs, os.path.join(m, "..", "..", "include"))

    if not tcl_library: raise RuntimeError, "not able to find tcl library"
    if not tk_library: raise RuntimeError, "not able to find tk library"
    libs.extend([tcl_library, tk_library])
    return {'include_dirs': include_dirs, 'library_dirs': lib_dirs, 
            'libraries': libs} 