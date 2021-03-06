PACKAGES=$(shell go list ./... | grep -v /vendor/)

help:
	@echo 'Available commands:'
	@echo
	@echo 'Usage:'
	@echo '    make deps     		Install go deps.'
	@echo '    make restore  		Restore all dependencies.'
	@echo '    make ci              Run in CI (e.g. Travis).'
	@echo '    make test  			Runs tests.'
	@echo '    make clean    		Clean the directory tree.'
	@echo

test: ## run tests, except integration tests
	@go test -v ${RACE} ${PACKAGES}

deps:
	go get -u github.com/tcnksm/ghr
	go get -u github.com/mitchellh/gox
	go get -u github.com/golang/dep/cmd/dep
	go get -u github.com/onsi/gomega
	go get -u github.com/onsi/ginkgo/ginkgo
	go get -u github.com/golang/lint/golint

lint:
	@golint

vet: ## run go vet
	@test -z "$$(go vet ${PACKAGES} 2>&1 | grep -v '*composite literal uses unkeyed fields|exit status 0)' | tee /dev/stderr)"

ci: lint vet test

restore:
	@dep ensure
