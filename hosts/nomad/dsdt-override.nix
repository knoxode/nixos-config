# Runtime DSDT override for nomad (Razer Blade 15 Mid 2019-Base).
#
# The EC firmware declares  OperationRegion (VRTC, SystemCMOS, Zero, 0x10)
# which Linux has no handler for (the CMOS RTC space handler only attaches
# when AML formally binds it to an RTC device; the Blade never does). Every
# access aborts with AE_NOT_EXIST, so \_SB.PCI0.LPCB.EC0.RTEC aborts and takes
# its callers (\_REG at EC install -> boot and every resume, \RWAK/\_WAK on
# every wake from suspend) with it before they finish their remaining
# statements.
#
# The shipped source is a copy of the vendor table with a single behavioural
# edit: RTEC's body is emptied. Its EC-RAM mirror fields (RTYR/RTMH/RTDY/
# RTHR/RTME) have no readers anywhere in the table, and the copy already
# aborts before writing anything, so stubbing it loses nothing while letting
# _REG/_WAK complete. Recompiling also surfaced 10 duplicate Case labels in
# ECRD/ECWT (iasl-as-compiler rejects them; the AML interpreter matches the
# first anyway), removed as unreachable dead code.
#
# Format: an uncompressed cpio segment carrying kernel/firmware/acpi/DSDT.aml,
# prepended to the initrd via boot.initrd.prepend. The kernel's ACPI table
# upgrade mechanism swaps the in-memory copy before any AML executes. The
# firmware chip itself is untouched and the override is trivially reversible.
{
  stdenvNoCC,
  acpica-tools,
  cpio,
}: let
  target = "kernel/firmware/acpi/DSDT.aml";
in
  stdenvNoCC.mkDerivation {
    name = "nomad-dsdt-override.cpio";
    nativeBuildInputs = [acpica-tools cpio];
    src = ./dsdt-patched.dsl;

    dontUnpack = true;

    buildPhase = ''
      iasl -p DSDT.aml "$src"
      test -f DSDT.aml
    '';

    installPhase = ''
      mkdir -p "$(dirname ${target})"
      cp DSDT.aml ${target}
      find kernel | cpio -H newc -o > "$out"
    '';
  }
