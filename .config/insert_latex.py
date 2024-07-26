""""Simple scripts that opens vim, allows you to write text there, and then inserts it wherever your cursor was before"""

import os
import subprocess
import tempfile

def open_vim(filename):
    subprocess.run([
        "alacritty",
        "--class", "'Alacritty floating'",
        "-e", "vim", f"{filename}"])

def open_file(mode=None):
    f = tempfile.NamedTemporaryFile(delete=False, suffix='.temp.tex')

    if mode == "ankitex":
        f.write(b"[latex]\n[/latex]")
        f.close()
    
    open_vim(f.name)

    filetext = ""
    with open(f.name, 'r') as g:
        filetext = g.read().strip()

    os.remove(f.name)

    subprocess.run(['xclip', '-selection', 'clipboard'], encoding='utf8', input=filetext)


if __name__ == "__main__":
    open_file(mode="ankitex")
