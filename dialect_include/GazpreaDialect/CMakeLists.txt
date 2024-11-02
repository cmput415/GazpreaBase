add_mlir_dialect(GazpreaDialect gazprea)
#add_mlir_doc(GazpreaDialect GazpreaDialect GazpreaDialect/ -gen-dialect-doc)
#add_mlir_doc(GazpreaOps GazpreaOps GazpreaDialect/ -gen-op-doc)

set(LLVM_TARGET_DEFINITIONS GazpreaPasses.td)
mlir_tablegen(GazpreaPasses.h.inc --gen-pass-decls)
#mlir_tablegen(GazpreaTypes.h.inc --gen-pass-decls)
#mlir_tablegen(GazpreaDialect.h.inc --gen-pass-decls)
mlir_tablegen(GazpreaOps.h.inc --gen-pass-decls)

add_public_tablegen_target(MLIRGazpreaPassesIncGen)
#add_public_tablegen_target(MLIRGazpreaDialectIncGen)
#add_public_tablegen_target(MLIRGazpreaTypesIncGen)
add_public_tablegen_target(MLIRGazpreaOpsIncGen)
