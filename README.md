# FreebasicNDS
Toolchain to cross compile freebasic programs for NDS  

<h2>Samples</h2>
https://github.com/MyTDT-Mysoft/FreebasicDS-SampleProjects  

<h1>Important</h1>  

To use it, please download a (windows for now) **release** because the github folder does not have the required (freebasic 0.25) and devkitpro installs to use it, but the github files (mainly the **modules** folder) can be used to update the toolchain until a new release is created (when theres changes to freebasic or devkitpro or other major essential changes)  and the sample folder is not on the release yet..

<h1>Usage</h1>  

the toolchain comes ready to use, however to use it you need a few config steps:  

1. **! ! VERY IMPORTANT ! !** open the **InitFolder.bat** and change the **set FrameWorkFolder=** to the full path that you extracted the release files.
1. create an empty folder **(no spaces on the path! ! !)**
1. copy the **InitFolder.bat** to that empty folder and run it  

This will create softlinks to some folders and files required to compile, it will also hide and protect them and delete the InitFolder.bat (so you wont see them) thats because right now it does still require the msys and a makefile to compile, so right now thats the setup i have for it.  

A **Drag_Bas_Here_To_Compile.bat** file is created along a sample .bas file and a config.bi file (the config.bi have some settings on what to enable or not... and what to include or not from freebasic runtime library (to minimize the compile time and output .nds file size), and other details that are special when using NDS, the freebasic runtime library and fbgfx are always compiled along the code of your program, to achieve as good optimization as possible for the NDS  
The **CrossConfig.bi** should probabily be included instead of hardcoded (like most samples so far have, because its better organized this way, even that its not currently used by any of the samples (because i just made it now to simplify for people who will have code that will work on both native and NDS), also note that the **\_\_FB_NDS\_\_** is defined so you can have code specific for NDS.  

<h1>Compatibility warnings</h1>  

**LINUX:** While i want to have this working on linux (and may be possible if the compile .bat and InitFolder.bat get translated to linux shell scripts (altough if you would install devkitpro and freebasic 0.25 there (not sure what required to have both current version freebasic and 0.25 installed at same time), would have it working..  

**Windows XP:** Everything from the toolchain and freeasic should work just fine on XP, however the **mklink**'s inside the **InitFolder.bat** must be changed to equivalent junctions (and i guess that since those are hardlinks then the project folder must be on the same partition... disk? as where the base folder is.
