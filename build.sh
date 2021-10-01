$BASE=`readlink -f .`
mkdir $BASE/src
cd $BASE/src
git clone https://github.com/gohugoio/hugo.git --depth 1 
cd $BASE/src/hugo
go install --tags extended

cd $BASE
hugo --gc --minify 
