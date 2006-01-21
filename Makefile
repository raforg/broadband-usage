version := 0.1
logdir := /var/log/broadband
prefix := /usr/local
bindir := $(prefix)/bin
mandir := $(shell [ -d $(prefix)/share/man ] && echo $(prefix)/share/man || echo $(prefix)/man)
cmdlog := broadband-usage-log
cmduse := broadband-usage

install:
	@set -e; \
	[ -d $(logdir) ] || mkdir $(logdir); \
	[ -d $(bindir) ] || mkdir $(bindir); \
	[ -d $(mandir) ] || mkdir $(mandir); \
	[ -d $(mandir)/man1 ] || mkdir $(mandir)/man1; \
	install -m 755 $(cmdlog) $(cmduse) $(bindir); \
	./$(cmdlog) -R > $(mandir)/man1/$(cmdlog).1; \
	./$(cmduse) -R > $(mandir)/man1/$(cmduse).1; \
	echo Now make sure that you own $(logdir); \
	echo and set up your crontab entries; \
	ls -laspd $(logdir)

uninstall:
	rm -f $(bindir)/$(cmduse) $(bindir)/$(cmdlog) $(mandir)/man1/$(cmdlog).1 $(mandir)/man1/$(cmduse).1

purge: uninstall
	rm -rf $(logdir)

test:
	@./TEST

check: test

dist:
	@base=`basename \`pwd\``; \
	cd ..; \
	ln -s $$base $$base-$(version); \
	tar chzf $$base-$(version).tar.gz $$base-$(version); \
	tar tvzf $$base-$(version).tar.gz; \
	rm -f $$base-$(version)

bak:
	@base=`basename \`pwd\``; \
	cd ..; \
	tar czf $$base.tar.gz $$base

help:
	@echo "This Makefile supports the following targets:"; \
	echo; \
	echo "  install   - Installs the commands, manpages and the log directory"; \
	echo "  uninstall - Uninstalls the commands and manpages "; \
	echo "  purge     - Same as uninstall + removes the log directory"; \
	echo "  test      - Runs some tests"; \
	echo "  check     - Same as test"; \
	echo "  dist      - Create the distribution tarball from the source"; \
	echo "  bak       - Create a backup tarball from the source"; \
	echo

