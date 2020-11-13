#!/usr/bin/env python3

# Auto fixes the yamllint warning `document-start`.
# Walks all the files in the `ansible` directory and executes yamllint on
# every yaml file. If the document start error is found it prepends the
# file with `---\n`.

import os
import subprocess
from pathlib import Path

def insertDocumentStart(path):
    p = Path(path)
    contents = p.read_text()
    contents = '---\n' + contents
    p.write_text(contents, encoding='utf8')

    return contents

for subdir, dirs, filenames in os.walk("../"):
    for filename in filenames:
        path = subdir + os.sep + filename

        if not path.endswith('.yml') or path.endswith('vault.yml'):
            continue

        proc = subprocess.run(
            'yamllint --strict ' + path,
            shell=True,
            stdout=subprocess.PIPE,
            encoding='utf8'
        )

        if 'missing document start' in proc.stdout:
            print('Inserting document start to:', path)
            insertDocumentStart(path)
