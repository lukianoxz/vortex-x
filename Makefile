ASM = nasm

# Diretórios
SRCDIR = src
BUILDDIR = build

# Arquivos
BOOT_SRC = $(SRCDIR)/arch/x86-64/bootloader/boot.asm
BOOT_BIN = $(BUILDDIR)/boot.bin
ISO = $(BUILDDIR)/vortex-x.iso

# Alvos
all: $(ISO)

$(BOOT_BIN): $(BOOT_SRC)
	$(ASM) $(BOOT_SRC) -f bin -o $(BOOT_BIN)

$(ISO): $(BOOT_BIN)
	mkdir -p $(BUILDDIR)/iso/boot/grub
	cp $(BOOT_BIN) $(BUILDDIR)/iso/boot/
	echo 'set timeout=0' > $(BUILDDIR)/iso/boot/grub/grub.cfg
	echo 'set default=0' >> $(BUILDDIR)/iso/boot/grub/grub.cfg
	echo 'menuentry "Vortex X" {' >> $(BUILDDIR)/iso/boot/grub/grub.cfg
	echo '  multiboot /boot/boot.bin' >> $(BUILDDIR)/iso/boot/grub/grub.cfg
	echo '}' >> $(BUILDDIR)/iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) $(BUILDDIR)/iso

run:
	qemu-system-x86_64 -cdrom $(ISO)

clean:
	rm -rf $(BUILDDIR)
