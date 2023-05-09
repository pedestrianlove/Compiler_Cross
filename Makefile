# Configure number of jobs that can be run concurrently
MAKEFLAGS := --jobs=$(shell nproc)
# PATHs
TOOL_PATH := /opt/cross_arm/
SOURCE_PATH := /opt/src/
LIBC_HEADERS := $(SOURCE_PATH)newlib/newlib/libc/include/

# CONFIGS
BINUTILS_CONFIG := --target=arm-elf-eabi --prefix=$(TOOL_PATH) --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
GCC_CONFIG := --target=arm-elf-eabi --prefix=$(TOOL_PATH) --enable-interwork --enable-multilib --enable-languages="c,c++" --with-float=soft --with-newlib --with-headers=$(LIBC_HEADERS) --disable-shared --with-gnu-as --with-gnu-ld --with-system-zlib

# Run with sudo make
install:
	# Setup system
	apt update -y && apt upgrade -y
	apt install -y libgmp-dev libmpfr-dev libmpc-dev texinfo

	# Fetch source
	apt install -y git build-essential bison flex
	mkdir -p $(TOOL_PATH)
	mkdir -p $(SOURCE_PATH)
	(cd $(SOURCE_PATH) && git clone -b master https://github.com/bminor/binutils-gdb.git binutils)
	(cd $(SOURCE_PATH) && git clone -b master https://github.com/bminor/newlib.git newlib)
	(cd $(SOURCE_PATH) && git clone -b master https://github.com/gcc-mirror/gcc.git)

build:
	# Build binutils
	(cd $(SOURCE_PATH)/binutils && \
		./configure $(BINUTILS_CONFIG) --disable-werror) && \
	($(MAKE) -i -C $(SOURCE_PATH)/binutils all install)

	# Build gcc
	(cd $(SOURCE_PATH)/gcc && \
		./configure $(GCC_CONFIG)) && \
	($(MAKE) -C $(SOURCE_PATH)/gcc all-gcc $(MAKEFLAGS) && \
		$(MAKE) -C $(SOURCE_PATH)/gcc install-gcc $(MAKEFLAGS))

	# Build newlib
	(cd $(SOURCE_PATH)/newlib && \
		./configure) && \
	($(MAKE) -C $(SOURCE_PATH)/newlib all $(MAKEFLAGS) && \
		$(MAKE) -C $(SOURCE_PATH)/newlib install $(MAKEFLAGS))

	# export PATH
	echo "export PATH=$$PATH:$(TOOL_PATH)/bin" >> /etc/bash.bashrc
