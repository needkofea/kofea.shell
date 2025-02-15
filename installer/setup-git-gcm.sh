#! /usr/bin/env bash


sudo pacman -Sy dotnet-runtime-8.0 --needed

dotnet tool install -g git-credential-manager
git-credential-manager configure
