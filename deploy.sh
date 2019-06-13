#!/bin/bash
echo 'start...'
hexo clean && hexo g && hexo d
echo "success..."