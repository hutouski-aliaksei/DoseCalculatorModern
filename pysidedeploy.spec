[app]

# title of your application
title = DoseCalculator

# project directory. the general assumption is that project_dir is the parent directory
# of input_file
project_dir = C:\Develope\DoseCalculator

# source file path
input_file = C:\Develope\DoseCalculator\main.py

# directory where exec is stored
exec_directory = .

# path to .pyproject project file
project_file = DoseCalculator.pyproject

# application icon
icon = C:\Develope\DoseCalculator\img\icon.ico

[python]

# python path
python_path = C:\Develope\DoseCalculator\venv68\Scripts\python.exe

# python packages to install
packages = Nuitka==2.4.8

# buildozer = for deploying Android application
android_packages = buildozer==1.5.0,cython==0.29.33

[qt]

# comma separated path to qml files required
# normally all the qml files required by the project are added automatically
qml_files = qml\main.qml,qml\der.qml,qml\coefficients.qml,qml\dynamic.qml

# excluded qml plugin binaries
excluded_qml_plugins = QtQuick3D,QtSensors,QtTest,QtWebEngine,QtWayland,QtCharts,QtDataVisualization,QtGrpc,QtTextToSpeech,QtWebChannel,QtWebSockets,QtWebView,QtGraphs

# qt modules used. comma separated
modules = QuickControls2,Quick,Core,Qml,Gui

# qt plugins used by the application
plugins = accessiblebridge,platformthemes,imageformats,platforms,iconengines,xcbglintegrations,styles,generic,platforms/darwin,platforminputcontexts,egldeviceintegrations,scenegraph,qmltooling

[android]

# path to pyside wheel
wheel_pyside = 

# path to shiboken wheel
wheel_shiboken = 

# plugins to be copied to libs folder of the packaged application. comma separated
plugins = 

[nuitka]

# usage description for permissions requested by the app as found in the info.plist file
# of the app bundle
# eg = extra_args = --show-modules --follow-stdlib
macos.permissions = 

# mode of using nuitka. accepts standalone or onefile. default is onefile.
mode = onefile

# (str) specify any extra nuitka arguments
extra_args = --quiet --noinclude-qt-translations --nofollow-import-to=tkinter --windows-icon-from-ico=img/icon.ico --windows-console-mode=disable

[buildozer]

# build mode
# possible options = [release, debug]
# release creates an aab, while debug creates an apk
mode = debug

# contrains path to pyside6 and shiboken6 recipe dir
recipe_dir = 

# path to extra qt android jars to be loaded by the application
jars_dir = 

# if empty uses default ndk path downloaded by buildozer
ndk_path = 

# if empty uses default sdk path downloaded by buildozer
sdk_path = 

# other libraries to be loaded. comma separated.
# loaded at app startup
local_libs = 

# architecture of deployed platform
# possible values = ["aarch64", "armv7a", "i686", "x86_64"]
arch = 

