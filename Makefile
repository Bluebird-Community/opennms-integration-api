.DEFAULT_GOAL := build

SHELL               := /bin/bash -o nounset -o pipefail -o errexit
MAVEN_SETTINGS_XML  ?= ./.cicd-assets/settings.xml
ARTIFACTS_DIR       := target/artifacts
MAVEN_ARGS          := --settings ${MAVEN_SETTINGS_XML} -Dstyle.color=always
CMAKE_ARGS          ?=
VERSION             := $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
BUILD_NUMBER        ?= 0

.PHONY: help
help:
	@echo ""
	@echo "Jrrd2 provides a native interface for Java to rrdtool."
	@echo "Artifacts are generated in the dist directory."
	@echo ""
	@echo "Goals:"
	@echo "  help:                Show this help for build goals"
	@echo "  build:               Compile and build the integration API
	@echo "  tests:               Run test suites for unit and integration tests
	@echo "  collect-testresults: Collect testresults and store them in $(ARTIFACTS_DIR)
	@echo "  clean:               Delete all build artifacts"
	@echo "  libyear:             Run libyear Maven pluginto show the freshness of lib dependencies"
	@echo ""

.PHONY: deps-build
deps-build:
	@echo "Check build dependencies: Java JDK, Maven and cmake"
	command -v mvn
	command -v java
	command -v javac
	echo $(VERSION)

.PHONY: build
build: deps-build
	mvn $(MAVEN_ARGS) dependency:resolve-plugins
	mvn $(MAVEN_ARGS) dependency:go-offline
	mvn $(MAVEN_ARGS) -DskipTests=true -DskipITs=true install

.PHONY: tests
tests: deps-build build
	mvn $(MAVEN_ARGS) -DskipTests=false -DskipITs=false verify

.PHONY: collect-testresults
collect-testresults:
	mkdir -p $(ARTIFACTS_DIR)/failsafe-reports $(ARTIFACTS_DIR)/surefire-reports
	find . -type f -regex ".*/target/failsafe-reports/.*xml" -exec cp {} $(ARTIFACTS_DIR)/failsafe-reports/ \;
	find . -type f -regex ".*/target/surefire-reports/.*xml" -exec cp {} $(ARTIFACTS_DIR)/surefire-reports/ \;

.PHONY: libyear
libyear: deps-build
	@echo "Analyze dependency freshness measured in libyear"
	@mkdir -p $(ARTIFACTS_DIR)/logs
	mvn $(MAVEN_ARGS) io.github.mfoo:libyear-maven-plugin:analyze 2>&1 | tee $(ARTIFACTS_DIR)/logs/libyear.log

.PHONY: deploy
deploy: deps-build
	mvn $(MAVEN_ARGS) -DskipTests deploy

.PHONY: clean
clean: deps-build
	mvn $(MAVEN_ARGS) clean
