#!/bin/bash
# Move into the testcase directory
cd "$(dirname "$0")"

echo "Compiling generator and solution..."
g++ -O3 generator.cpp -o generator
g++ -O3 solution.cpp -o solution

echo "Generating input files..."
./generator

echo "Generating output files..."
./solution < sample.in > sample.out
./solution < small_edge.in > small_edge.out
./solution < medium.in > medium.out
./solution < large_stress.in > large_stress.out

echo "All test cases generated successfully!"
ls -la
