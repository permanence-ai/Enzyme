; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function drelu
; RUN: %opt < %s %loadEnzyme -enzyme -enzyme-preopt=false -mem2reg -inline -early-cse -instcombine -simplifycfg -S | FileCheck %s

%struct.Gradients = type { double, double }

; Function Attrs: nounwind
declare %struct.Gradients @__enzyme_fwddiff(double (double)*, ...)


define dso_local double @f(double %x) #1 {
entry:
  ret double %x
}

define dso_local double @relu(double %x) {
entry:
  %cmp = fcmp fast ogt double %x, 0.000000e+00
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %call = tail call fast double @f(double %x)
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi double [ %call, %cond.true ], [ 0.000000e+00, %entry ]
  ret double %cond
}

define dso_local %struct.Gradients @drelu(double %x) {
;
entry:
  %0 = tail call %struct.Gradients (double (double)*, ...) @__enzyme_fwddiff(double (double)* nonnull @relu, metadata !"enzyme_width", i64 2, double %x, double 0.0, double 1.0)
  ret %struct.Gradients %0
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone noinline }


; CHECK: define dso_local %struct.Gradients @drelu(double [[X:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_I:%.*]] = fcmp fast ogt double [[X]], 0.000000e+00
; CHECK-NEXT:    br i1 [[CMP_I]], label [[COND_TRUE_I:%.*]], label [[FWDDIFFE2RELU_EXIT:%.*]]
; CHECK:       cond.true.i:
; CHECK-NEXT:    [[TMP0:%.*]] = call {{(fast )?}}[2 x double] @fwddiffe2f(double [[X]], [2 x double] [double 0.000000e+00, double 1.000000e+00])
; CHECK-NEXT:    br label [[FWDDIFFE2RELU_EXIT]]
; CHECK:       fwddiffe2relu.exit:
; CHECK-NEXT:    [[TMP1:%.*]] = phi {{(fast )?}}[2 x double] [ [[TMP0]], [[COND_TRUE_I]] ], [ zeroinitializer, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue [2 x double] [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue [[STRUCT_GRADIENTS:%.*]] zeroinitializer, double [[TMP2]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue [2 x double] [[TMP1]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = insertvalue [[STRUCT_GRADIENTS]] [[TMP3]], double [[TMP4]], 1
; CHECK-NEXT:    ret [[STRUCT_GRADIENTS]] [[TMP5]]
