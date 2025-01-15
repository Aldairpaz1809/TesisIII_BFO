#!/bin/bash
energia=$(grep "!" *out|awk '{print $5}')
echo "$energia" > datos.dat
