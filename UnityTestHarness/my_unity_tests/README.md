Instructions for running my Unity test harness tests
====================

### Adolfo Neto
### September 20th, 2011

These tests are based on the tests presented by James Grenning in his book "Test Driven Development for Embedded C" (http://pragprog.com/book/jgade/test-driven-development-for-embedded-c).

1. Install Unity latest version from http://sourceforge.net/projects/unity/ 
2. Put the full path for the folder where you installed Unity in the "UNITY_FOLDER" variable on Makefile
3. Run the following
   $ make

The result should be something like:

> rm -f build/*.o ; rm -f stdio.out 

> gcc -Isrc -I/home/adolfo/Dropbox/code/tdd_embedded_c/unity/src -I/home/adolfo/Dropbox/code/tdd_embedded_c/unity/extras/fixture/src -DTEST /home/adolfo/Dropbox/code/tdd_embedded_c/unity/src/unity.c test/stdio/SprintfTest.c test/stdio/no_ruby/SprintfTest_Runner.c -o stdio.out

> stdio.out

> test/stdio/SprintfTest.c:32:test_string_hey_is_as_expected:PASS

> test/stdio/SprintfTest.c:37:test_string_hello_is_as_expected:PASS

> -----------------------

> 2 Tests 0 Failures 0 Ignored

> OK


This was tested with:

* Unity 2_0_113
* gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) 
* Linux 2.6.35-30-generic #59-Ubuntu SMP Tue Aug 30 19:00:03 UTC 2011 x86_64 GNU/Linux

 



