
build:
	ulimit -n 4096
	./dist_passingcuriosity.com/build/pc/pc build

sync:
	rsync -vr _site/ forceit.in:/var/www/passingcuriosity.com/htdocs

push: build sync
