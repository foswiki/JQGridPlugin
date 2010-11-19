FOSWIKI_ROOT?=~/foswiki/trunk/core
TARGET=jquery.jqgrid.js jquery.jqgrid.init.js
SUBDIRS=i18n css

JSSOURCE=\
   ui.multiselect.js \
   grid.base.js\
   jquery.fmatter.js\
   jquery.additional-fmatter.js\
   grid.custom.js\
   grid.common.js\
   grid.formedit.js\
   jquery.searchFilter.js\
   grid.inlinedit.js\
   grid.celledit.js\
   jqModal.js\
   jqDnR.js\
   grid.subgrid.js\
   grid.treegrid.js\
   grid.import.js\
   JsonXml.js\
   grid.setcolumns.js\
   grid.postext.js\
   grid.tbltogrid.js\
   grid.jqueryui.js

-include Makefile.include

jquery.jqgrid.uncompressed.js: $(JSSOURCE)
	@echo creating $@ from JSSOURCE
	@$(CAT) $^ > $@

