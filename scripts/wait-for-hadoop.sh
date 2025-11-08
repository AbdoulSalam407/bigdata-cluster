#!/bin/bash
echo "Waiting for HDFS to be ready..."
until hdfs dfsadmin -report 2>/dev/null; do
    echo "HDFS not ready, waiting..."
    sleep 10
done
echo "HDFS is ready!"