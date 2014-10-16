function Test()
	local originalFiles =
	{
		'Jamfile.jam',
		'test.lua',
		'app/Jamfile.jam',
		'app/main.c',
		'lib-a/Jamfile.jam',
		'lib-a/add.c',
		'lib-a/add.h',
	}

	local originalDirs =
	{
		'app/',
		'lib-a/',
	}

	do
		-- Test for a clean directory.
		RunJam{ 'clean' }
		TestDirectories(originalDirs)
		TestFiles(originalFiles)
	end

	---------------------------------------------------------------------------
	local dirs
	local files
	local patternA
	local patternB
	local patternC
	local patternD
	
	if Platform == 'win32' then
		dirs =
		{
			'app/',
			'lib-a/',
			'app/$(TOOLCHAIN_PATH)/',
			'app/$(TOOLCHAIN_PATH)/app/',
			'lib-a/$(TOOLCHAIN_PATH)/',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/',
		}

		files = {
			'Jamfile.jam',
			'test.lua',
			'app/Jamfile.jam',
			'app/main.c',
			'app/$(TOOLCHAIN_PATH)/app/app.release.exe',
			'?app/$(TOOLCHAIN_PATH)/app/app.release.exe.intermediate.manifest',
			'app/$(TOOLCHAIN_PATH)/app/app.release.pdb',
			'app/$(TOOLCHAIN_PATH)/app/main.obj',
			'lib-a/add.c',
			'lib-a/add.h',
			'lib-a/Jamfile.jam',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/add.obj',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/lib-a.release.lib',
		}
	
		patternA = [[
*** found 12 target(s)...
*** updating 6 target(s)...
@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):app>main.obj
!NEXT!@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):lib-a>add.obj
!NEXT!@ C.$(COMPILER).Archive <$(TOOLCHAIN_GRIST):lib-a>lib-a.lib
!NEXT!@ C.$(COMPILER).Link <$(TOOLCHAIN_GRIST):app>app.exe
!NEXT!*** updated 6 target(s)...
]]

		patternB = [[
*** found 12 target(s)...
]]

		patternC = [[
*** found 12 target(s)...
*** updating 2 target(s)...
@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):app>main.obj
!NEXT!@ C.$(COMPILER).Link <$(TOOLCHAIN_GRIST):app>app.exe
!NEXT!*** updated 2 target(s)...
]]

		patternD = [[
*** found 12 target(s)...
]]

	else
		dirs = {
			'app/',
			'lib-a/',
			'app/$(TOOLCHAIN_PATH)/',
			'app/$(TOOLCHAIN_PATH)/app/',
			'lib-a/$(TOOLCHAIN_PATH)/',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/',
		}

		files = {
			'Jamfile.jam',
			'test.lua',
			'app/Jamfile.jam',
			'app/main.c',
			'app/$(TOOLCHAIN_PATH)/app/app.release',
			'app/$(TOOLCHAIN_PATH)/app/main.o',
			'lib-a/add.c',
			'lib-a/add.h',
			'lib-a/Jamfile.jam',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/add.o',
			'lib-a/$(TOOLCHAIN_PATH)/lib-a/lib-a.release.a',
		}

		patternA = [[
*** found 12 target(s)...
*** updating 6 target(s)...
@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):app>main.o 
@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):lib-a>add.o 
@ C.$(COMPILER).Archive2 <$(TOOLCHAIN_GRIST):lib-a>lib-a.a 
@ C.$(COMPILER).Link <$(TOOLCHAIN_GRIST):app>app
*** updated 6 target(s)...
]]

		patternB = [[
*** found 12 target(s)...
]]

		patternC = [[
*** found 12 target(s)...
*** updating 2 target(s)...
@ C.$(COMPILER).CC <$(TOOLCHAIN_GRIST):app>main.o 
@ C.$(COMPILER).Link <$(TOOLCHAIN_GRIST):app>app
*** updated 2 target(s)...
]]

		patternD = [[
*** found 12 target(s)...
]]

	end

	do
		TestPattern(patternA, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		TestPattern(patternB, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		osprocess.sleep(1.0)
		ospath.touch('lib-a/add.h')

		TestPattern(patternC, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		TestPattern(patternD, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	RunJam{ 'clean' }
	TestFiles(originalFiles)
	TestDirectories(originalDirs)
end
