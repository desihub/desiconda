
SHELL = /bin/bash

# Check required environment variables

ifndef CONFIG
  CONFIG := $(error CONFIG undefined)undefined
endif

ifndef VERSION
  gitdesc := $(shell git describe --tags --dirty --always | cut -d "-" -f 1)
  gitcnt := $(shell git rev-list --count HEAD)
  VERSION := "$(gitdesc).dev$(gitcnt)"
endif

# Make seems to delete these...

.PRECIOUS : $(wildcard conf/*)

# Config related files

CONFIG_FILE := conf/$(CONFIG)

# The files with the build rules for each dependency

rules_full := $(wildcard rules/*)
rules_sh := $(foreach rl,$(rules_full),$(subst rules/,,$(rl)))
rules := $(foreach rl,$(rules_sh),$(subst .sh,,$(rl)))

# For depending on the helper scripts and templates

TOOLS := $(wildcard ./tools/*)

# Based on the config file name, are we building a docker file
# or an install script?

DOCKERCHECK := $(findstring docker,$(CONFIG))
ifeq "$(DOCKERCHECK)" "docker"
  SPECTRO := Dockerfile_spectro_$(CONFIG)
  SURVEY := Dockerfile_survey_$(CONFIG)
else
  SPECTRO := install_spectro_$(CONFIG).sh
  SURVEY := install_survey_$(CONFIG).sh
  ifndef PREFIX
    PREFIX := $(error PREFIX undefined)undefined
  endif
endif

# Allow manually specifying the modulefiles directory.
# Otherwise install to PREFIX/modulefiles

ifndef MODULEDIR
  MODULEDIR := "$(PREFIX)/modulefiles"
endif


.PHONY : help script clean


help :
	@echo " "
	@echo " Before using this Makefile, set the CONFIG and PREFIX environment"
	@echo " variables.  The VERSION environment variable is optional.  The"
	@echo " following targets are supported:"
	@echo " "
	@echo "    spectro  : Build the install script or Dockerfile for the spectro pipeline."
	@echo "    survey   : Build the install script or Dockerfile for the imaging survey."
	@echo "    clean    : Clean all generated files."
	@echo " "


spectro : $(CONFIG_FILE) $(TOOLS) $(SPECTRO)
	@echo "" >/dev/null

survey : $(CONFIG_FILE) $(TOOLS) $(SURVEY)
	@echo "" >/dev/null


Dockerfile_spectro_$(CONFIG) : $(CONFIG_FILE) $(TOOLS) Dockerfile_spectro.template
	@./tools/apply_conf.sh Dockerfile_spectro.template "Dockerfile_spectro_$(CONFIG)" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" yes

Dockerfile_survey_$(CONFIG) : $(CONFIG_FILE) $(TOOLS) Dockerfile_survey.template
	@./tools/apply_conf.sh Dockerfile_survey.template "Dockerfile_survey_$(CONFIG)" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" yes


install_spectro_$(CONFIG).sh : $(CONFIG_FILE) $(TOOLS) install.template
	@./tools/apply_conf.sh install.template "install_spectro_$(CONFIG).sh" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& chmod +x "install_spectro_$(CONFIG).sh" \
	&& ./tools/gen_modulefile.sh tools/modulefile.in "install_spectro_$(CONFIG).sh.modtemplate" "$(CONFIG_FILE).module" \
	&& ./tools/apply_conf.sh "install_spectro_$(CONFIG).sh.modtemplate" "install_spectro_$(CONFIG).sh.module" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& ./tools/apply_conf.sh tools/version.in "install_spectro_$(CONFIG).sh.modversion" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no

install_survey_$(CONFIG).sh : $(CONFIG_FILE) $(TOOLS) install.template
	@./tools/apply_conf.sh install.template "install_survey_$(CONFIG).sh" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& chmod +x "install_survey_$(CONFIG).sh" \
	&& ./tools/gen_modulefile.sh tools/modulefile.in "install_survey_$(CONFIG).sh.modtemplate" "$(CONFIG_FILE).module" \
	&& ./tools/apply_conf.sh "install_survey_$(CONFIG).sh.modtemplate" "install_survey_$(CONFIG).sh.module" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& ./tools/apply_conf.sh tools/version.in "install_survey_$(CONFIG).sh.modversion" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no


Dockerfile_spectro.template : tools/Dockerfile_spectro.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/Dockerfile_spectro.in Dockerfile_spectro.template "$(rules)" RUN

Dockerfile_survey.template : tools/Dockerfile_survey.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/Dockerfile_survey.in Dockerfile_survey.template "$(rules)" RUN


install_spectro.template : tools/install_spectro.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/install_spectro.in install_spectro.template "$(rules)"

install_survey.template : tools/install_survey.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/install_survey.in install_survey.template "$(rules)"


clean :
	@rm -f Dockerfile_* install_*

