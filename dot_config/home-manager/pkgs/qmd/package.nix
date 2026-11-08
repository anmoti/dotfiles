{
  runCommand,
  coreutils,
  lib,
  mesa,
  vulkan-loader,
  qmd,
}:

let
  vulkanLibs = lib.makeLibraryPath [
    mesa
    vulkan-loader
  ];
in

# Upstream's wrapper exports a Nix glibc in LD_LIBRARY_PATH and then runs `uname -s`.
# On a non-NixOS host that resolves to the host's /usr/bin/uname, which aborts with
# "stack smashing detected" (glibc mismatch). Use Nix's uname instead.
#
# GPU backends are exposed portably (no vendor is assumed):
#  - Vulkan: every Mesa ICD shipped by Nix (Intel/AMD/NVK/llvmpipe/...) is offered.
#    Host ICDs are skipped (built against a newer glibc than the wrapper's).
#  - CUDA: if the host has the NVIDIA driver (libcuda.so.1) and CUDA toolkit
#    (/opt/cuda), they are exposed at runtime (Nix can't reference host libs at
#    build time). node-llama-cpp then auto-picks the best available backend.
runCommand "qmd" { inherit (qmd) meta; } ''
  mkdir -p $out/bin
  sed 's|\$(uname -s)|$(${coreutils}/bin/uname -s)|' ${qmd}/bin/qmd > $out/bin/qmd

  sed -i "s|^\(export LD_LIBRARY_PATH='\)|\1${vulkanLibs}:|" $out/bin/qmd

  # The upstream wrapper ends with `exec bun ...`; move that line out so the
  # portable backend logic (below) runs before exec.
  _exec_line=$(grep '^exec ' $out/bin/qmd)
  sed -i '/^exec /d' $out/bin/qmd

  # Append portable GPU backend logic (auto-detect). Uses Nix coreutils because
  # host coreutils crash under the wrapper's Nix glibc in LD_LIBRARY_PATH.
  {
    printf '%s\n' '# --- portable GPU backend exposure (auto-detect) ---'

    printf '%s\n' 'if [ -z "''${VK_ICD_FILENAMES:-}" ]; then'
    printf '%s\n' '  _icds=""'
    printf '%s\n' '  for _f in '"${mesa}"'/share/vulkan/icd.d/*.json; do'
    printf '%s\n' '    [ -e "$_f" ] || continue'
    printf '%s\n' '    if [ -z "$_icds" ]; then _icds="$_f"; else _icds="$_icds:$_f"; fi'
    printf '%s\n' '  done'
    printf '%s\n' '  if [ -n "$_icds" ]; then export VK_ICD_FILENAMES="$_icds"; fi'
    printf '%s\n' 'fi'
    printf '%s\n' 'if [ -z "''${VK_DRIVER_FILES:-}" ] && [ -n "''${VK_ICD_FILENAMES:-}" ]; then export VK_DRIVER_FILES="''${VK_ICD_FILENAMES}"; fi'

    printf '%s\n' '# CUDA: expose host NVIDIA driver + CUDA toolkit if present (NVIDIA only).'
    printf '%s\n' 'if [ -e /usr/lib/libcuda.so.1 ] && { [ -d /opt/cuda/lib64 ] || [ -d /usr/local/cuda/lib64 ]; }; then'
    printf '%s\n' '  if [ -d /opt/cuda/lib64 ]; then _cuda_libdir=/opt/cuda/lib64; else _cuda_libdir=/usr/local/cuda/lib64; fi'
    printf '%s\n' '  _cuda_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/qmd-cuda-libs"'
    printf '%s\n' '  _cuda_src="$('"${coreutils}"'/bin/readlink -f /usr/lib/libcuda.so.1 2>/dev/null)"'
    printf '%s\n' '  _cuda_stamp="$_cuda_dir/.stamp"'
    printf '%s\n' '  if [ ! -f "$_cuda_stamp" ] || [ "$('"${coreutils}"'/bin/cat "$_cuda_stamp" 2>/dev/null)" != "$_cuda_src" ]; then'
    printf '%s\n' '    '"${coreutils}"'/bin/rm -rf "$_cuda_dir" 2>/dev/null || true'
    printf '%s\n' '    '"${coreutils}"'/bin/mkdir -p "$_cuda_dir" 2>/dev/null || true'
    printf '%s\n' '    '"${coreutils}"'/bin/cp -L /usr/lib/libcuda.so* "$_cuda_dir/" 2>/dev/null || true'
    printf '%s\n' '    '"${coreutils}"'/bin/printf "%s" "$_cuda_src" > "$_cuda_stamp" 2>/dev/null || true'
    printf '%s\n' '  fi'
    printf '%s\n' '  if [ -d "$_cuda_dir" ]; then export LD_LIBRARY_PATH="$_cuda_dir:$_cuda_libdir:$LD_LIBRARY_PATH"; fi'
    printf '%s\n' 'fi'
    printf '%s\n' '# --- end portable GPU backend exposure ---'
  } >> $out/bin/qmd
  ${coreutils}/bin/printf '%s\n' "$_exec_line" >> $out/bin/qmd

  chmod +x $out/bin/qmd
  grep -q '${coreutils}/bin/uname' $out/bin/qmd
  grep -q '${vulkanLibs}' $out/bin/qmd
''
