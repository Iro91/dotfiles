all:
	stow --verbose --target=$$HOME --restow home/
clean:
	stow --verbose --target=$$HOME --delete home/
