#!/bin/bash

set -e

chmod -R a+rw .

sudo -u build makepkg --syncdeps --noconfirm
