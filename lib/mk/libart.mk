ANDROID_PORT = libart
ANDROID_DIR = art
ANDROID_BUILDFILES = test/Android.bp build/Android.bp runtime/Android.bp
ANDROID_SECTIONS = \
	/art_cc_library[@name=libart] \
	/art_cc_library[@name=libart]/arch/$(ANDROID_ARCH) \
	/gensrcs[@name=art_operator_srcs]

# We want to override Thread::InitCpu() and Thread::CleanupCpu()
ANDROID_EXCLUDE_CC += arch/x86_64/thread_x86_64.cc

# We want to overrid art::Exec()
ANDROID_EXCLUDE_CC += exec_utils.cc

include $(call select_from_repositories,lib/mk/libart-defaults.inc)
include $(call select_from_repositories,lib/mk/android-lib.inc)

BASEDIR = $(call select_from_ports,libart)/art/runtime
GENTOOL = $(BASEDIR)/$($(ANDROID_NAME)_TOOL_FILES)
HEADERS = $(addprefix $(BASEDIR)/,$(filter %.h,$($(ANDROID_NAME)_SRCS)))
OUTPUT  = $($(ANDROID_NAME)_OUTPUT_EXTENSION)
GENDIR  = $(LIB_CACHE_DIR)/$(ANDROID_BUILDTYPE)/$(ANDROID_NAME)

$(GENDIR)/$(OUTPUT): $(HEADERS)
	$(VERBOSE)$(GENTOOL) $(BASEDIR) $(HEADERS) > $@.tmp
	$(VERBOSE)mv $@.tmp $@

vpath % $(GENDIR) $(call select_from_repositories,src/lib/libart)
SRC_C += $(OUTPUT)

# Genode implementations
SRC_C += signal.c runtime_genode.cc thread_genode.cc exec_genode.cc

# Linux monitoring implementation is a dummy, so reuse it
SRC_C += monitor_linux.cc

#
# FIXME: SUPPRESS WARNINGS! DEVELOPMENT ONLY - REMOVE FOR PRODUCTION!
$(warning SUPPRESSING WARNINGS - REMOVE FOR PRODUCTION!)
CC_OPT += -w

LIBS += libsigchain
