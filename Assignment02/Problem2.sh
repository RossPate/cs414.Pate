#!/bin/bash

# Regex for C++ identifiers
cpp_id_regex="^[a-zA-Z_][a-zA-Z0-9_]*$"

echo "Testing C++ identifiers:"

# Test cases
tests=("myVariable" "_private_func" "class_name123" "123_invalid" "has-hyphen")

for t in "${tests[@]}"; do
    if [[ $t =~ $cpp_id_regex ]]; then
        echo "$t -> true"
    else
        echo "$t -> false"
    fi
done

# Regex for U.S. phone numbers
phone_regex="^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"

echo "Testing U.S. phone numbers:"

# Test cases
tests2=("(123) 456-7890" "987-654-3210" "1234567890" "(123)456-7890")

for t2 in "${tests2[@]}"; do
    if [[ $t2 =~ $phone_regex ]]; then
        echo "$t2 -> true"
    else
        echo "$t2 -> false"
    fi
done

# Regex for floating point numbers
float_regex="^[+-]?([0-9]+(\.[0-9]*)?|\.[0-9]+)$"

echo "Testing floating point numbers:"

# Test cases
tests3=("123" "+123.45" "-.5" "67." "not a number")

for t3 in "${tests3[@]}"; do
    if [[ $t3 =~ $float_regex ]]; then
        echo "$t3 -> true"
    else
        echo "$t3 -> false"
    fi
done

# Regex for binary palindromes of length 3 or 4
palindrome_regex="^(0|1)(0|1)?\\2\\1$"

echo "Testing binary palindromes (length 3 or 4):"

# Test cases
tests4=("101" "0110" "111" "0000" "10" "10010")

for t4 in "${tests4[@]}"; do
    if [[ $t4 =~ $palindrome_regex ]]; then
        echo "$t4 -> true"
    else
        echo "$t4 -> false"
    fi
done

### End of script