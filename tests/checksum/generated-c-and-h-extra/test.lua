function TestChecksum()
    -- Test for a clean directory.
    local originalFiles = {
        'Jamfile.jam',
        'main.c',
        'notgenerated.h',
        'template-c',
        'template-h',
    }

    local originalDirs = {
    }

    -- Clean up everything.
    RunJam{ 'clean' }
    TestDirectories(originalDirs)
    TestFiles(originalFiles)

    ---------------------------------------------------------------------------
    local files
    local dirs = {
        'generateme/',
        '$(TOOLCHAIN_PATH)/test/',
    }

    local function TestNoopPattern()
        local noopPattern = [[
*** found 14 target(s)...
]]
        TestPattern(noopPattern, RunJam{})
        TestDirectories(dirs)
        TestFiles(files)
    end

    local pattern
    if Platform == 'win32' then
        files = {
            'Jamfile.jam',
            'main.c',
            'notgenerated.h',
            'template-c',
            'template-h',
            'generateme/generated.c',
            'generateme/generated.h',
            '$(TOOLCHAIN_PATH)/test/generated.obj',
            '$(TOOLCHAIN_PATH)/test/main.obj',
            '$(TOOLCHAIN_PATH)/test/test.exe',
            '$(TOOLCHAIN_PATH)/test/test.pdb',
        }

        pattern = [[
*** found 13 target(s)...
*** updating 7 target(s)...
@ GenerateH <$(TOOLCHAIN_GRIST):generateme>generated.h
@ GenerateC <$(TOOLCHAIN_GRIST):generateme>generated.c
@ $(C_CC) <$(TOOLCHAIN_GRIST):test>main.obj
!NEXT!@ $(C_LINK) <$(TOOLCHAIN_GRIST):test>test.exe
!NEXT!*** updated 7 target(s)...
]]
    else
        files = {
            'Jamfile.jam',
            'main.c',
            'notgenerated.h',
            'template-c',
            'template-h',
            'generateme/generated.c',
            'generateme/generated.h',
            '$(TOOLCHAIN_PATH)/test/generated.o',
            '$(TOOLCHAIN_PATH)/test/main.o',
            '$(TOOLCHAIN_PATH)/test/test',
        }

        pattern = [[
*** found 13 target(s)...
*** updating 7 target(s)...
@ $(C_CC) <$(TOOLCHAIN_GRIST):test>main.o
@ GenerateH <$(TOOLCHAIN_GRIST):generateme>generated.h
@ GenerateC <$(TOOLCHAIN_GRIST):generateme>generated.c
@ $(C_CC) <$(TOOLCHAIN_GRIST):test>generated.o
@ $(C_LINK) <$(TOOLCHAIN_GRIST):test>test
*** updated 7 target(s)...
]]
    end

    ---------------------------------------------------------------------------
    do
        TestPattern(pattern, RunJam{})
        TestDirectories(dirs)
        TestFiles(files)
    end

    ---------------------------------------------------------------------------
    do
        TestNoopPattern()
    end

    ---------------------------------------------------------------------------
    do
        TestNoopPattern()
    end

    ---------------------------------------------------------------------------
    RunJam{ 'clean' }
    TestFiles(originalFiles)
    TestDirectories(originalDirs)
end
