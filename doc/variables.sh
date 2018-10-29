#! /bin/sh

buildpath='docs/_build/html'
buildstatic=$( ls -d $buildpath/* )
buildfolder=$( ls -d $buildpath/*/ )

echo "all folders"
echo $buildfolder
echo "all files"
echo $buildstatic
