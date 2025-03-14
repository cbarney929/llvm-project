! RUN: bbc -emit-fir -hlfir=false %s -o - | FileCheck %s --check-prefixes=CHECK,CMPLX,CMPLX-PRECISE,%if flang-supports-f128-math %{F128%} %else %{F64%}
! RUN: bbc -emit-fir -hlfir=false --math-runtime=precise %s -o - | FileCheck %s --check-prefixes="CMPLX,CMPLX-PRECISE"
! RUN: bbc --force-mlir-complex -emit-fir -hlfir=false %s -o - | FileCheck %s --check-prefixes="CMPLX,CMPLX-FAST"
! RUN: %flang_fc1 -emit-fir -flang-deprecated-no-hlfir %s -o - | FileCheck %s --check-prefixes=CHECK,CMPLX,CMPLX-PRECISE,%if flang-supports-f128-math %{F128%} %else %{F64%}
! RUN: %flang_fc1 -emit-fir -flang-deprecated-no-hlfir -mllvm --math-runtime=precise %s -o - | FileCheck %s --check-prefixes="CMPLX,CMPLX-PRECISE"
! RUN: %flang_fc1 -emit-fir -flang-deprecated-no-hlfir -mllvm --force-mlir-complex %s -o - | FileCheck %s --check-prefixes="CMPLX,CMPLX-FAST"
! RUN: %flang_fc1 -fapprox-func -emit-fir -flang-deprecated-no-hlfir %s -o - | FileCheck %s --check-prefixes="CMPLX,CMPLX-APPROX"

! Test abs intrinsic for various types (int, float, complex)

! CHECK-LABEL: func @_QPabs_testi
! CHECK-SAME: %[[VAL_0:.*]]: !fir.ref<i32>{{.*}}, %[[VAL_1:.*]]: !fir.ref<i32>
subroutine abs_testi(a, b)
! CHECK:  %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<i32>
! CHECK:  %[[VAL_3:.*]] = arith.constant 31 : i32
! CHECK:  %[[VAL_4:.*]] = arith.shrsi %[[VAL_2]], %[[VAL_3]] : i32
! CHECK:  %[[VAL_5:.*]] = arith.xori %[[VAL_2]], %[[VAL_4]] : i32
! CHECK:  %[[VAL_6:.*]] = arith.subi %[[VAL_5]], %[[VAL_4]] : i32
! CHECK:  fir.store %[[VAL_6]] to %[[VAL_1]] : !fir.ref<i32>
! CHECK:  return
  integer :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testi16
! CHECK-SAME: %[[VAL_0:.*]]: !fir.ref<i128>{{.*}}, %[[VAL_1:.*]]: !fir.ref<i128>
subroutine abs_testi16(a, b)
! CHECK:  %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<i128>
! CHECK:  %[[VAL_3:.*]] = arith.constant 127 : i128
! CHECK:  %[[VAL_4:.*]] = arith.shrsi %[[VAL_2]], %[[VAL_3]] : i128
! CHECK:  %[[VAL_5:.*]] = arith.xori %[[VAL_2]], %[[VAL_4]] : i128
! CHECK:  %[[VAL_6:.*]] = arith.subi %[[VAL_5]], %[[VAL_4]] : i128
! CHECK:  fir.store %[[VAL_6]] to %[[VAL_1]] : !fir.ref<i128>
! CHECK:  return
  integer(kind=16) :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testh(
! CHECK-SAME:  %[[VAL_0:.*]]: !fir.ref<f16>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f16>{{.*}}) {
subroutine abs_testh(a, b)
! CHECK: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<f16>
! CHECK: %[[VAL_2_1:.*]] = fir.convert %[[VAL_2]] : (f16) -> f32
! CHECK: %[[VAL_3:.*]] = math.absf %[[VAL_2_1]] {{.*}}: f32
! CHECK: %[[VAL_3_1:.*]] = fir.convert %[[VAL_3]] : (f32) -> f16
! CHECK: fir.store %[[VAL_3_1]] to %[[VAL_1]] : !fir.ref<f16>
! CHECK: return
  real(kind=2) :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testb(
! CHECK-SAME:  %[[VAL_0:.*]]: !fir.ref<bf16>{{.*}}, %[[VAL_1:.*]]: !fir.ref<bf16>{{.*}}) {
subroutine abs_testb(a, b)
! CHECK: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<bf16>
! CHECK: %[[VAL_2_1:.*]] = fir.convert %[[VAL_2]] : (bf16) -> f32
! CHECK: %[[VAL_3:.*]] = math.absf %[[VAL_2_1]] {{.*}}: f32
! CHECK: %[[VAL_3_1:.*]] = fir.convert %[[VAL_3]] : (f32) -> bf16
! CHECK: fir.store %[[VAL_3_1]] to %[[VAL_1]] : !fir.ref<bf16>
! CHECK: return
  real(kind=3) :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testr(
! CHECK-SAME:  %[[VAL_0:.*]]: !fir.ref<f32>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f32>{{.*}}) {
subroutine abs_testr(a, b)
! CHECK: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<f32>
! CHECK: %[[VAL_3:.*]] = math.absf %[[VAL_2]] {{.*}}: f32
! CHECK: fir.store %[[VAL_3]] to %[[VAL_1]] : !fir.ref<f32>
! CHECK: return
  real :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testd(
! CHECK-SAME:  %[[VAL_0:.*]]: !fir.ref<f64>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f64>{{.*}}) {
subroutine abs_testd(a, b)
! CHECK: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<f64>
! CHECK: %[[VAL_3:.*]] = math.absf %[[VAL_2]] {{.*}}: f64
! CHECK: fir.store %[[VAL_3]] to %[[VAL_1]] : !fir.ref<f64>
! CHECK: return
  real(kind=8) :: a, b
  b = abs(a)
end subroutine

! CHECK-LABEL: func @_QPabs_testr16(
! F128-SAME:  %[[VAL_0:.*]]: !fir.ref<f128>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f128>{{.*}}) {
! F64-SAME:  %[[VAL_0:.*]]: !fir.ref<f64>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f64>{{.*}}) {
subroutine abs_testr16(a, b)
! F128: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<f128>
! F64: %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<f64>
! F128: %[[VAL_3:.*]] = math.absf %[[VAL_2]] {{.*}}: f128
! F64: %[[VAL_3:.*]] = math.absf %[[VAL_2]] {{.*}}: f64
! F128: fir.store %[[VAL_3]] to %[[VAL_1]] : !fir.ref<f128>
! F64: fir.store %[[VAL_3]] to %[[VAL_1]] : !fir.ref<f64>
! CHECK: return
  integer, parameter :: rk = merge(16, 8, selected_real_kind(33, 4931)==16)
  real(kind=rk) :: a, b
  b = abs(a)
end subroutine

! CMPLX-LABEL: func @_QPabs_testzr(
! CMPLX-SAME:  %[[VAL_0:.*]]: !fir.ref<complex<f32>>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f32>{{.*}}) {
subroutine abs_testzr(a, b)
! CMPLX:  %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<complex<f32>>
! CMPLX-FAST: %[[VAL_4:.*]] = complex.abs %[[VAL_2]] fastmath<contract> : complex<f32>
! CMPLX-APPROX: %[[VAL_4:.*]] = complex.abs %[[VAL_2]] fastmath<contract,afn> : complex<f32>
! CMPLX-PRECISE:  %[[VAL_4:.*]] = fir.call @cabsf(%[[VAL_2]]) {{.*}}: (complex<f32>) -> f32
! CMPLX:  fir.store %[[VAL_4]] to %[[VAL_1]] : !fir.ref<f32>
! CMPLX:  return
  complex :: a
  real :: b
  b = abs(a)
end subroutine abs_testzr

! CMPLX-LABEL: func @_QPabs_testzd(
! CMPLX-SAME:  %[[VAL_0:.*]]: !fir.ref<complex<f64>>{{.*}}, %[[VAL_1:.*]]: !fir.ref<f64>{{.*}}) {
subroutine abs_testzd(a, b)
! CMPLX:  %[[VAL_2:.*]] = fir.load %[[VAL_0]] : !fir.ref<complex<f64>>
! CMPLX-FAST: %[[VAL_4:.*]] = complex.abs %[[VAL_2]] fastmath<contract> : complex<f64>
! CMPLX-APPROX: %[[VAL_4:.*]] = complex.abs %[[VAL_2]] fastmath<contract,afn> : complex<f64>
! CMPLX-PRECISE:  %[[VAL_4:.*]] = fir.call @cabs(%[[VAL_2]]) {{.*}}: (complex<f64>) -> f64
! CMPLX:  fir.store %[[VAL_4]] to %[[VAL_1]] : !fir.ref<f64>
! CMPLX:  return
  complex(kind=8) :: a
  real(kind=8) :: b
  b = abs(a)
end subroutine abs_testzd
