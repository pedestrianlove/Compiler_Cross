# PATHs
TOOL_PATH=/opt/cross_arm/
SOURCE_PATH=/opt/src/

# CONFIGS
BINUTILS_CONFIG=--target=arm-elf-eabi --prefix=$TOOL_PATH --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
GCC_CONFIG=--target=arm-elf-eabi --prefix=$(TOOL_PATH) --enable-interwork --enable-multilib --enable-languages="c,c++" --with-float=soft --with-newlib --with-headers=$(LIBC_HEADERS) --disable-shared --with-gnu-as --with-gnu-ld --with-system-zlib


install:
	# Setup system
	sudo su
	apt update -y && apt upgrade -y
	apt install -y libgmp-dev libmpfr-dev libmpc-dev texinfo

	# Fetch source
	apt install -y git build-essential
	mkdir -p $(TOOL_PATH)
	mkdir -p $(SOURCE_PATH) && cd $(SOURCE_PATH)
	git clone https://sourceware.org/git/binutils-gdb.git binutils & \
	git clone https://sourceware.org/git/newlib-cygwin.git newlib & \
	git clone https://gcc.gnu.org/git/gcc.git

	# Build binutils
	cd $(SOURCE_PATH)/binutils
	./configure $(BINUTILS_CONFIG) --prefix=$(TOOL_PATH) --target=arm-elf-eabi --disable-werror
	make all install

	# Build gcc
	cd $(SOURCE_PATH)/gcc
	./configure $(GCC_CONFIG)
	make all-gcc && make install-gcc

	# Build newlib
	cd $(SOURCE_PATH)/newlib
	./configure
	make all && make install

	# export PATH
	export PATH=$PATH:$(TOOL_PATH)/bin


