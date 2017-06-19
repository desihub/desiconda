
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

# Override arcane Make suffix rule for SCCS which 
# wipes our config scripts...

% : %.sh

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
  SURVEY := Dockerfile_imaging_$(CONFIG)
  CBUILD := Dockerfile_condabld_$(CONFIG)
else
  SPECTRO := install_spectro_$(CONFIG).sh
  SURVEY := install_imaging_$(CONFIG).sh
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
	@echo "    imaging  : Build the install script or Dockerfile for the imaging survey."
	@echo "    condabld : Build the Dockerfile for use in conda builds."
	@echo "    clean    : Clean all generated files."
	@echo " "


spectro : $(CONFIG_FILE) $(TOOLS) $(SPECTRO)
	@echo "" >/dev/null

imaging : $(CONFIG_FILE) $(TOOLS) $(SURVEY)
	@echo "" >/dev/null

condabld : $(CONFIG_FILE) $(TOOLS) $(CBUILD)
	@echo "" >/dev/null


Dockerfile_spectro_$(CONFIG) : $(CONFIG_FILE) $(TOOLS) Dockerfile_spectro.template
	@./tools/apply_conf.sh Dockerfile_spectro.template "Dockerfile_spectro_$(CONFIG)" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" yes

Dockerfile_imaging_$(CONFIG) : $(CONFIG_FILE) $(TOOLS) Dockerfile_imaging.template
	@./tools/apply_conf.sh Dockerfile_imaging.template "Dockerfile_imaging_$(CONFIG)" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" yes

Dockerfile_condabld_$(CONFIG) : $(CONFIG_FILE) $(TOOLS) Dockerfile_condabld.template
	@./tools/apply_conf.sh Dockerfile_condabld.template "Dockerfile_condabld_$(CONFIG)" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" yes


install_spectro_$(CONFIG).sh : $(CONFIG_FILE) $(TOOLS) install_spectro.template
	@./tools/apply_conf.sh install_spectro.template "install_spectro_$(CONFIG).sh" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& chmod +x "install_spectro_$(CONFIG).sh" \
	&& ./tools/gen_modulefile.sh tools/modulefile.in "install_spectro_$(CONFIG).sh.modtemplate" "$(CONFIG_FILE).module" \
	&& ./tools/apply_conf.sh "install_spectro_$(CONFIG).sh.modtemplate" "install_spectro_$(CONFIG).sh.module" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& ./tools/apply_conf.sh tools/version.in "install_spectro_$(CONFIG).sh.modversion" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no

install_imaging_$(CONFIG).sh : $(CONFIG_FILE) $(TOOLS) install_imaging.template
	@./tools/apply_conf.sh install_imaging.template "install_imaging_$(CONFIG).sh" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& chmod +x "install_imaging_$(CONFIG).sh" \
	&& ./tools/gen_modulefile.sh tools/modulefile.in "install_imaging_$(CONFIG).sh.modtemplate" "$(CONFIG_FILE).module" \
	&& ./tools/apply_conf.sh "install_imaging_$(CONFIG).sh.modtemplate" "install_imaging_$(CONFIG).sh.module" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no \
	&& ./tools/apply_conf.sh tools/version.in "install_imaging_$(CONFIG).sh.modversion" "$(CONFIG_FILE)" "$(PREFIX)" "$(VERSION)" "$(MODULEDIR)" no


Dockerfile_spectro.template : tools/Dockerfile_spectro.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/Dockerfile_spectro.in Dockerfile_spectro.template "$(rules)" RUN

Dockerfile_imaging.template : tools/Dockerfile_imaging.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/Dockerfile_imaging.in Dockerfile_imaging.template "$(rules)" RUN

Dockerfile_condabld.template : tools/Dockerfile_condabld.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/Dockerfile_condabld.in Dockerfile_condabld.template "$(rules)" RUN


install_spectro.template : tools/install_spectro.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/install_spectro.in install_spectro.template "$(rules)"

install_imaging.template : tools/install_imaging.in $(rules_full) $(TOOLS)
	@./tools/gen_template.sh tools/install_imaging.in install_imaging.template "$(rules)"


clean :
	@rm -f Dockerfile_* install_*

