; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs
; RUN: %opt < %s %loadEnzyme -enzyme -enzyme-preopt=false -mem2reg -early-cse -simplifycfg -S | FileCheck %s

; Function Attrs: nounwind
declare void @__enzyme_fwddiff.f64(...)

; Function Attrs: noinline nounwind uwtable
define dso_local float @man_max(float* %a, float* %b) #0 {
entry:
  %0 = load float, float* %a, align 4
  %1 = load float, float* %b, align 4
  %cmp = fcmp ogt float %0, %1
  %a.b = select i1 %cmp, float* %a, float* %b
  %retval.0 = load float, float* %a.b, align 4
  ret float %retval.0
}

define void @dman_max(float* %a, float* %da1, float* %da2, float* %da3, float* %b, float* %db1, float* %db2, float* %db3) {
entry:
  call void (...) @__enzyme_fwddiff.f64(float (float*, float*)* @man_max, metadata !"enzyme_width", i64 3, float* %a, float* %da1, float* %da2, float* %da3, float* %b, float* %db1, float* %db2, float* %db3)
  ret void
}

attributes #0 = { noinline }


; CHECK: define {{[^@]+}}@fwddiffe3man_max(float* [[A:%.*]], [3 x float*] %"a'", float* [[B:%.*]], [3 x float*] %"b'") 
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[A]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[B]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue [3 x float*] %"a'", 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue [3 x float*] %"b'", 0
; CHECK-NEXT:    %"a.b'ipse" = select i1 [[CMP]], float* [[TMP2]], float* [[TMP3]]
; CHECK-NEXT:    [[TMP4:%.*]] = insertvalue [3 x float*] undef, float* %"a.b'ipse", 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractvalue [3 x float*] %"a'", 1
; CHECK-NEXT:    [[TMP6:%.*]] = extractvalue [3 x float*] %"b'", 1
; CHECK-NEXT:    %"a.b'ipse1" = select i1 [[CMP]], float* [[TMP5]], float* [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = insertvalue [3 x float*] [[TMP4]], float* %"a.b'ipse1", 1
; CHECK-NEXT:    [[TMP8:%.*]] = extractvalue [3 x float*] %"a'", 2
; CHECK-NEXT:    [[TMP9:%.*]] = extractvalue [3 x float*] %"b'", 2
; CHECK-NEXT:    %"a.b'ipse2" = select i1 [[CMP]], float* [[TMP8]], float* [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = insertvalue [3 x float*] [[TMP7]], float* %"a.b'ipse2", 2
; CHECK-NEXT:    %"retval.0'ipl" = load float, float* %"a.b'ipse", align 4
; CHECK-NEXT:    [[TMP11:%.*]] = insertvalue [3 x float] undef, float %"retval.0'ipl", 0
; CHECK-NEXT:    %"retval.0'ipl3" = load float, float* %"a.b'ipse1", align 4
; CHECK-NEXT:    [[TMP12:%.*]] = insertvalue [3 x float] [[TMP11]], float %"retval.0'ipl3", 1
; CHECK-NEXT:    %"retval.0'ipl4" = load float, float* %"a.b'ipse2", align 4
; CHECK-NEXT:    [[TMP13:%.*]] = insertvalue [3 x float] [[TMP12]], float %"retval.0'ipl4", 2
; CHECK-NEXT:    ret [3 x float] [[TMP13]]
;
