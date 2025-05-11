#!/bin/bash

echo "Number of raw reads for each file:"
	grep -c '^@' ~/genome/*gz

echo "Total number of raw reads in all four files:"
	total_lines=$(cat ~/genome/*gz | wc -l)
	total_reads=$(( $total_lines / 4 ))
	echo $total_reads

echo "Total base pairs of data:"
	total_bp=$(( $total_reads *250 *2 ))
	echo $total_bp

echo "Average coverage:"
	avg_cov=$(( $total_bp / 7000000 ))
	echo $avg_cov

