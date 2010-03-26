TARGET=\
  jquery.jqgrid.js \
  jquery.jqgrid.init.js

SUBDIRS=i18n css

JSSOURCE=\
  grid.base.js \
  grid.common.js \
  grid.formedit.js \
  grid.inlinedit.js \
  grid.celledit.js \
  grid.subgrid.js \
  grid.treegrid.js \
  grid.custom.js \
  grid.postext.js \
  grid.tbltogrid.js \
  grid.setcolumns.js \
  grid.import.js \
  jquery.fmatter.js \
  JsonXml.js \
  jquery.searchFilter.js

-include Makefile.include

jquery.jqgrid.uncompressed.js: $(JSSOURCE)
	@echo creating $@ from JSSOURCE
	@$(CAT) $^ > $@

