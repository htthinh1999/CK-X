#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/2/Dockerfile
if [ -f "$F" ] && grep -q -E "FROM golang:1.20-alpine AS builder|FROM golang:1.20-alpine as builder" "$F"; then
  echo "Success: builder stage defined"
  exit 0
else
  echo "Error: builder stage (FROM golang:1.20-alpine AS builder) not found"
  exit 1
fi
