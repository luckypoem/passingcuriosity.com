
build:
	./dist_passingcuriosity.com/build/pc/pc build


clean:
	./dist_passingcuriosity.com/build/pc/pc clean

sync:
	rsync -vr _site/ forceit.in:/var/www/passingcuriosity.com/htdocs

push: build sync
