#include <gtest/gtest.h>

#include "../src/add.h"

TEST(BasicAddition, AddsTwoIntegers) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
}
