#!/usr/bin/env bash

tag="giogt/jdk"
version="1.8.0u151"

docker build -t $tag:$version .
