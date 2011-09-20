#include "unity.h"
#include <setjmp.h>
#include <stdio.h>

char MessageBuffer[50];

extern void setUp(void);
extern void tearDown(void);

extern void test_string_hey_is_as_expected(void);
extern void test_string_hello_is_as_expected(void);


static void runTest(UnityTestFunction test)
{
  if (TEST_PROTECT())
  {
      setUp();
      test();
  }
  if (TEST_PROTECT() && !TEST_IS_IGNORED)
  {
    tearDown();
  }
}
void resetTest()
{
  tearDown();
  setUp();
}


int main(void)
{
  Unity.TestFile = "test/stdio/SprintfTest.c";
  UnityBegin();

  // RUN_TEST calls runTest
  RUN_TEST(test_string_hey_is_as_expected, 32);
  RUN_TEST(test_string_hello_is_as_expected, 37);

  UnityEnd();
  return 0;
}
