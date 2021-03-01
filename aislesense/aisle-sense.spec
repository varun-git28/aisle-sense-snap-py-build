# -*- mode: python ; coding: utf-8 -*-

block_cipher = None


a = Analysis(['aisle-sense.py'],
             pathex=['/home/app/aisle_build_automation_py/aislesense'],
             binaries=[],
             datas=[('/home/app/aisle_build_automation_py/aislesense/wesense_utilities/deployment_tools/inference_engine/lib/intel64/plugins.xml', '.')],
             hiddenimports=['/home/app/aisle_build_automation_py/aislesense/wesense_utilities/python/python3.5/openvino'],
             hookspath=['/home/app/aisle_build_automation_py/aislesense'],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='aisle-sense',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=True )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='aisle-sense')
