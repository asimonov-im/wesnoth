OPTIMIZE_TYPE=$(filter g, $(VARIANTLIST))

all: build/wesnoth

build/wesnoth:
ifeq ($(OPTIMIZE_TYPE),)
	$(WESNOTH_ROOT)/build_for_playbook.sh --root $(WESNOTH_ROOT) -p $(WESNOTH_ROOT)/.. --pkg-config $(WESNOTH_ROOT)/../install/lib/pkgconfig
else
	$(WESNOTH_ROOT)/build_for_playbook.sh --debug --root $(WESNOTH_ROOT) -p $(WESNOTH_ROOT)/.. --pkg-config $(WESNOTH_ROOT)/../install/lib/pkgconfig
endif

clean:
	rm -rf build
	
#ifndef QCONFIG
#QCONFIG=qconfig.mk
#endif
#include $(QCONFIG)
#
#USEFILE=
#
#include $(MKFILES_ROOT)/qmacros.mk
#
## Suppress the _g suffix from the debug variant
#BUILDNAME=$(IMAGE_PREF_$(BUILD_TYPE))$(NAME)$(IMAGE_SUFF_$(BUILD_TYPE))
#
## Extra include path for libfreetype and for target overrides and patches
#EXTRA_INCVPATH+=$(QNX_TARGET)/usr/include/freetype2 \
#	$(QNX_TARGET)/../target-override/usr/include
#
## Extra library search path for target overrides and patches
#EXTRA_LIBVPATH+=$(QNX_TARGET)/../target-override/$(CPUVARDIR)/lib \
#	$(QNX_TARGET)/../target-override/$(CPUVARDIR)/usr/lib
#
## Compiler options for enhanced security
#CCFLAGS+=-fstack-protector-all -D_FORTIFY_SOURCE=2 \
#	$(if $(filter g so shared,$(VARIANTS)),,-fPIE)
#
## Linker options for enhanced security
#LDFLAGS+=-Wl,-z,relro -Wl,-z,now $(if $(filter g so shared,$(VARIANTS)),,-pie)
#
## Basic libraries required by most native applications
#LIBS+=bps
#
#include $(MKFILES_ROOT)/qtargets.mk
#
#OPTIMIZE_TYPE_g=none
#OPTIMIZE_TYPE=$(OPTIMIZE_TYPE_$(filter g, $(VARIANTS)))
