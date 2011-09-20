#include "unity.h"
#include <stdio.h>
#include <memory.h>

static char output[100];
static const char * expected;

void setUp(void)
{
    memset(output, 0xaa, sizeof output);
    expected = "";
}

void tearDown(void)
{
}


void expect(const char * s)
{
    expected = s;
}

void given(int charsWritten)
{
    TEST_ASSERT_EQUAL(strlen(expected), charsWritten);
    TEST_ASSERT_EQUAL_STRING(expected, output);
    TEST_ASSERT_EQUAL_HEX8(0xaa, output[strlen(expected) + 1]);
}


void test_string_hey_is_as_expected(void){
    expect("hey");
    given(sprintf(output, "hey"));
}

void test_string_hello_is_as_expected(void){
    expect("Hello World\n");
    given(sprintf(output, "Hello %s\n", "World"));
}

