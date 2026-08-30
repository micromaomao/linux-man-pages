# Copyright, the authors of the Linux man-pages project
# SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception


ifndef MAKEFILE_CONFIGURE_BUILD_DEPENDS_BINUTILS_LD_INCLUDED
MAKEFILE_CONFIGURE_BUILD_DEPENDS_BINUTILS_LD_INCLUDED ::= 1


include $(MAKEFILEDIR)/configure/build-depends/cpp/cpp.mk
include $(MAKEFILEDIR)/configure/build-depends/gcc/cc.mk
include $(MAKEFILEDIR)/configure/build-depends/coreutils/echo.mk
include $(MAKEFILEDIR)/configure/build-depends/coreutils/mktemp.mk
include $(MAKEFILEDIR)/configure/build-depends/coreutils/rm.mk
include $(MAKEFILEDIR)/configure/build-depends/pkgconf/pkgconf.mk
include $(MAKEFILEDIR)/configure/verbose.mk


ifndef LD
LD ::= $(CC) $(CFLAGS_) $(CPPFLAGS_)
endif


LD_HAS_FUSE_LINKER_PLUGIN ::= \
	$(shell \
		tmp=$$($(MKTEMP) --suffix=.o); \
		$(ECHO) 'int main(void) {}' \
		| $(CC) -x c -c -o $$tmp /dev/stdin $(HIDE_ERR); \
		$(LD) -fuse-linker-plugin -o /dev/null $$tmp $(HIDE_ERR) \
		&& $(ECHO) yes \
		|| $(ECHO) no; \
	)


DEFAULT_LDFLAGS ::= \
	-Wl,--as-needed \
	-Wl,--no-allow-shlib-undefined \
	-Wl,--no-copy-dt-needed-entries \
	-Wl,--no-undefined \
	$(shell $(PKGCONF_CMD) --libs-only-L $(PKGCONF_LIBS) $(HIDE_ERR)) \
	$(shell $(PKGCONF_CMD) --libs-only-other $(PKGCONF_LIBS) $(HIDE_ERR))

ifeq ($(LD_HAS_FUSE_LINKER_PLUGIN),yes)
DEFAULT_LDFLAGS += -fuse-linker-plugin
endif

ifndef LDFLAGS
LDFLAGS         ::=
endif
ifndef LDFLAGS_
LDFLAGS_        ::= $(DEFAULT_LDFLAGS) $(LDFLAGS)
endif


DEFAULT_LDLIBS ::= \
	-lc \
	$(shell $(PKGCONF_CMD) --libs-only-l $(PKGCONF_LIBS) $(HIDE_ERR))
ifndef LDLIBS
LDLIBS         ::=
endif
ifndef LDLIBS_
LDLIBS_        ::= $(DEFAULT_LDLIBS) $(LDLIBS)
endif


endif  # include guard
