FOSWIKI_ROOT?=~/foswiki/core
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
   jquery.tablednd.js \
   jquery.contextmenu.js \
   grid.subgrid.js\
   grid.treegrid.js\
   grid.grouping.js\
   grid.import.js\
   JsonXml.js\
   grid.setcolumns.js\
   grid.postext.js\
   grid.tbltogrid.js\
   grid.jqueryui.js\
   grid.filter.js \
   grid.addons.js

-include Makefile.include

jquery.jqgrid.uncompressed.js: $(JSSOURCE)
	@echo creating $@ from JSSOURCE
	@$(CAT) $^ > $@

