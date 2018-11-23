#!/bin/bash

# month -> awk -F, '{print $(NF)}' /var/tmp/log
# sys -> NF-1
# user -> NF-2