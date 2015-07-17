TARGET=jquery.jqgrid.css

-include ../Makefile.include

CSSSOURCE=\
  ui.jqgrid.css \
  ui.multiselect.css \
  jquery.searchFilter.css 


#  myfixes.css 

jquery.jqgrid.uncompressed.css: $(CSSSOURCE)
	@echo creating $@ from $^
	@$(CAT) $^ > $@

