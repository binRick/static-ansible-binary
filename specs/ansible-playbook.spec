# -*- mode: python -*-
import os, six, ansible
block_cipher = None

a = Analysis(['ansible-playbook.py'],
             pathex=None,
             binaries=None,
             datas=[
                 (six.__file__, '.'),
                 (os.path.dirname(ansible.__file__), 'ansible')
             ],
             hiddenimports=['uuid', 'ansible', 'configparser', 'smtplib', 'logging.handlers', 'distutils.version', 'pty', 'watchdog', 'watchdog.observers', 'watchdog.events', 'ansible.plugins.callback.*', 'email.mime', 'ansible.cli.connection', 'email.mime.*', 'ansible.constants', 'ansible.*'],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='ansible-playbook',
          debug=False,
          strip=False,
          upx=True,
          console=True)
