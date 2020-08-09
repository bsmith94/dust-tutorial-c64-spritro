#
#
# Build the dust tutorial.
#
#

# copy make.defs.sample to make.defs and edit the paths
include make.defs

CLEAN=rm -rf
MKDIR=mkdir -p

BUILD=dustlayer-spritro
PROG_PRG=$(BUILD).prg
PROG_CBM=$(BUILD).cbm

BUILDPATH=build
SOURCE=index.asm
INCLUDEPATH=code
INCLUDES= \
	$(INCLUDEPATH)/config_resources.asm \
	$(INCLUDEPATH)/config_sprites.asm \
	$(INCLUDEPATH)/config_symbols.asm \
	$(INCLUDEPATH)/data_text.asm \
	$(INCLUDEPATH)/main.asm \
	$(INCLUDEPATH)/sub_check_keyboard.asm \
	$(INCLUDEPATH)/sub_clear_screen.asm \
	$(INCLUDEPATH)/sub_color_cycle.asm \
	$(INCLUDEPATH)/sub_update_ship.asm \
	$(INCLUDEPATH)/sub_write_text.asm

RESOURCESPATH=resources
RESOURCES= \
	$(RESOURCESPATH)/empty_1000.sid \
	$(RESOURCESPATH)/rambo_font.ctm \
	$(RESOURCESPATH)/sprites.spr

all:: dirs compile crunch

dirs: $(BUILDPATH)

$(BUILDPATH):
	$(MKDIR) $@

clean:
	$(CLEAN) $(BUILDPATH)

compile: $(BUILDPATH)/$(PROG_CBM)

$(BUILDPATH)/$(PROG_CBM): $(SOURCE) $(INCLUDES) $(RESOURCES) dirs
	$(ACMEPATH)/acme \
		-r $(BUILDPATH)/buildreport \
		--vicelabels $(BUILDPATH)/labels \
		--msvc \
		--color \
		--format cbm \
		-v3 \
		--outfile $@ \
		$<

crunch: $(BUILDPATH)/$(PROG_PRG)

$(BUILDPATH)/$(PROG_PRG): $(BUILDPATH)/$(PROG_CBM)
	$(CRUNCHERPATH)/pucrunch \
		-x0x0801 \
		-c64 \
		-g55 \
		-fshort $< \
		$@

run: $(BUILDPATH)/$(PROG_PRG)
	$(EMULATORPATH)/x64 $(EMULATORARGS) $<
