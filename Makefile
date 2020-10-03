install: build deploy

build:
	mm build --name LCD1602 --input . --output ./LCD1602

clean:
	rm -r ./LCD1602

deploy:
	mm library --install ./LCD1602

uninstall:
	mm library --uninstall LCD1602
