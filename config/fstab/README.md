# K1 storage target (SPACEMIT_STORAGE)

The fstab is generated from `fstab.in` by `gen_fstab_k1`, selected by the
`SPACEMIT_STORAGE` build flag (set in `device/spacemit/k1/device.mk`):

| Value    | fstab device                     | Controller            |
|----------|----------------------------------|-----------------------|
| `emmc`   | `soc:storage-bus/d4281000.mmc`   | onboard eMMC (default)|
| `sdcard` | `soc:storage-bus/d4280000.mmc`   | microSD (`&sdhci0`)   |
| `ssd`    | `/dev/block/by-name/*`           | NVMe over PCIe — experimental |

Build for a target:

    SPACEMIT_STORAGE=sdcard m        # or set it in the product/env before `m`

The flag only changes **where Android mounts its partitions**. Making the board
actually run from that storage also needs (per target, done on hardware):

- **sdcard**: write the GPT + images to the microSD (fastboot/dd to `&sdhci0`),
  point U-Boot's boot device at the SD, and set the boot-ROM straps for SD.
- **ssd**: additionally requires PCIe + NVMe drivers in the **first-stage**
  ramdisk (not late vendor_dlkm modules) so the `by-name` links exist for
  first_stage_mount, the partition table on the NVMe, and U-Boot booting the
  boot image from NVMe. Untested — treat as experimental until validated.

`emmc` is the only fully validated path today.
