###### tags: `compiler` `hw` `thu`

# Compiler: Cross Compiler

## 1. 打開vacs


## 2. 進入su更新軟體並安裝需要的library
```bash
sudo su

apt update

apt upgrade

apt install libgmp-dev libmpfr-dev libmpc-dev texinfo
```
![](https://hackmd.io/_uploads/SyTNvHv42.png)


## 3. 取得原始碼
- 使用aria2取得最新的原始碼，以在稍後的編譯設定參數。
- 建議可順便安裝tmux使其可以同時執行多個工作。
```bash
apt install build-essential flex bison aria2

mkdir /opt/cross_arm

mkdir /opt/src && cd /opt/src
```
- 新開一檔在`/opt/src/sources`，貼入下面內容， 存檔離開。
```
https://github.com/bminor/binutils-gdb/archive/refs/heads/master.zip
https://github.com/bminor/newlib/archive/refs/heads/master.zip
https://github.com/gcc-mirror/gcc/archive/refs/heads/master.zip
```
- 輸入下面指令：
```bash
aria2c -i sources -j4

unzip '*.zip'

mv binutils-gdb-master binutils

mv gcc-master gcc

mv newlib-master newlib
```

![](https://hackmd.io/_uploads/S1MuuHvNn.png)


## 4. 建立資料夾並設定編譯參數
```bash
export TOOL_PATH=/opt/cross_arm/

export SOURCE_PATH=/opt/src/

export PATH=$TOOL_PATH/bin:$PATH

export LIBC_HEADERS=$SOURCE_PATH/newlib/newlib/libc/include
```
![](https://hackmd.io/_uploads/S1Bx9BPVn.png)


## 5. 使用`./configure`產生`Makefile`，並使用`make`編譯
- binutils
```bash!
cd /opt/src/binutils

./configure --target=arm-elf-eabi --prefix=$TOOL_PATH --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls

make all install
```

- gcc
```bash!
cd /opt/src/gcc

./configure --target=arm-elf-eabi --prefix=$TOOL_PATH --enable-interwork --enable-multilib --enable-languages="c,c++" --with-float=soft --with-newlib --with-headers=$LIBC_HEADERS --disable-shared --with-gnu-as --with-gnu-ld --with-system-zlib

make install-gcc
```

- newlib
```bash!
cd /opt/src/newlib

./configure

make all && make install
```
    

## 4. 寫一個簡單的程式(以Hello World為例):
```c
#include <stdio.h>
#include <stdlib.h>

int main ()
{
    printf ("Hello World!\n");
}
```
- 存成`test.c`

## 5. 使用cross-compiler編譯成armv7的assembly:
```bash
/opt/cross_arm/bin/arm-elf-eabi-gcc -S test.c
```
![](https://hackmd.io/_uploads/SkGLJhO42.png)


## 6. 得到arm的組合語言(`test.s`):
![](https://hackmd.io/_uploads/Bk9VMqPN3.png)
