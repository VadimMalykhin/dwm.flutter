.PHONY: clean
clean:
	rm -rf pubspec.lock
	rm -rf example/build
	rm -rf example/pubspec.lock
	flutter clean
	flutter pub get
