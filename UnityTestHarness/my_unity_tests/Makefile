C_COMPILER=gcc
TARGET_BASE1=stdio
ifeq ($(OS),Windows_NT)
	TARGET_EXTENSION=.exe
else
	TARGET_EXTENSION=.out
endif
UNITY_FOLDER=/home/adolfo/Dropbox/code/tdd_embedded_c/unity
TARGET1 = $(TARGET_BASE1)$(TARGET_EXTENSION)
SRC_FILES1=$(UNITY_FOLDER)/src/unity.c test/stdio/SprintfTest.c test/stdio/no_ruby/SprintfTest_Runner.c
INC_DIRS=-Isrc -I$(UNITY_FOLDER)/src -I$(UNITY_FOLDER)/extras/fixture/src
SYMBOLS=-DTEST

ifeq ($(OS),Windows_NT)
	CLEANUP = del /F /Q build\* && del /F /Q $(TARGET1) 
else
	CLEANUP = rm -f build/*.o ; rm -f $(TARGET1) 
endif

all: clean default

default:
#	ruby auto/generate_test_runner.rb test/TestProductionCode.c  test/no_ruby/TestProductionCode_Runner.c
#	ruby auto/generate_test_runner.rb test/TestProductionCode2.c test/no_ruby/TestProductionCode2_Runner.c
	$(C_COMPILER) $(INC_DIRS) $(SYMBOLS) $(SRC_FILES1) -o $(TARGET1)
	$(TARGET1)

clean:
	$(CLEANUP)
	
