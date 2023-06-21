; RUN: llvm-as %s -o %t.bc
; RUN: llvm-spirv --spirv-ext=+SPV_INTEL_cache_controls -spirv-text %t.bc -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: llvm-spirv --spirv-ext=+SPV_INTEL_cache_controls %t.bc -o %t.spv
; RUN: llvm-spirv -r %t.spv --spirv-target-env=SPV-IR -o - | llvm-dis -o - | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-SPIRV: Constant 6 [[MemoryScope:[0-9]+]] 2
; CHECK-SPIRV: Constant 6 [[MemorySemantics:[0-9]+]] 528
; CHECK-SPIRV: CacheFlushINTEL 1 [[MemoryScope]] [[MemorySemantics]]

; CHECK-LLVM: call spir_func void @_Z23__spirv_CacheFlushINTELiii(i32 1, i32 2, i32 528)

target triple = "spir64-unknown-unknown"

; Function Attrs: nounwind
define spir_kernel void @test() {
entry:
  call spir_func void @_Z23__spirv_CacheFlushINTELiii(i32 1, i32 2, i32 528)
  ret void
}

declare spir_func void @_Z23__spirv_CacheFlushINTELiii(i32, i32, i32)

!spirv.MemoryModel = !{!0}
!spirv.Source = !{!1}
!opencl.spir.version = !{!2}
!opencl.ocl.version = !{!2}

!0 = !{i32 2, i32 2}
!1 = !{i32 3, i32 102000}
!2 = !{i32 1, i32 2}
