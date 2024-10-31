//===- Ops.td - Gazprea dialect operation definitions ----------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//
//
// Defines the operations of the Gazprea dialect.
//
//===----------------------------------------------------------------------===//

#ifndef GAZPREA_OPS
#define GAZPREA_OPS

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// Define the Gazprea dialect in the ODS framework to define ops
def Gazprea_Dialect : Dialect {
  // Create the dialect namespace
  let name = "gazprea";

  // Summary of the dialect
  let summary = "A simple dialect to allow for the addition of structs to the Gazprea language";

  // a longer description //TODO
  let description = [{}];

  // We set this bit to generate the declarations for the dialect's type parsing
  // and printing hooks.
  let useDefaultTypePrinterParser = 1;

  // The c++ namespace in which the dialect class should reside
  let cppNamespace = "::mlir::gazprea";
}

// Base class for gazprea dialect operations. This operation inherits from the base
// `Op` class in OpBase.td, and provides:
//   * The parent dialect of the operation.
//   * The mnemonic for the operation, or the name without the dialect prefix.
//   * A list of traits for the operation.
class Gazprea_Op<string mnemonic, list<Trait> traits = []> :
    Op<Gazprea_Dialect, mnemonic, traits>;

// Provide a definition for the Gazprea StructType for use in ODS. This allows for
// using StructType in a similar way to Tensor or MemRef. We use `DialectType`
// to demarcate the StructType as belonging to the Gazprea dialect.
def Gazprea_StructType :
    DialectType<Gazprea_Dialect, CPred<"::llvm::isa<StructType>($_self)">,
                "Gazprea struct type">;

// Provide a definition of the types that are used within the Gazprea dialect.
def Gazprea_Type : AnyTypeOf<[Gazprea_StructType]>;

//===----------------------------------------------------------------------===//
// Gazprea Operations
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// StructAccessOp
//===----------------------------------------------------------------------===//

def StructAccessOp : Gazprea_Op<"struct_access", [Pure]> {
  let summary = "struct access";
  let description = [{
    Access the Nth element of a value returning a struct type.
  }];

  let arguments = (ins Gazprea_StructType:$input, I64Attr:$index);
  let results = (outs AnyType:$output);

  let assemblyFormat = [{
    $input `[` $index `]` attr-dict `:` type($input) `->` type($output)
  }];

  // Allow building a StructAccessOp with just a struct value and an index.
  let builders = [
    OpBuilder<(ins "Value":$input, "size_t":$index)>
  ];

  // Indicate that additional verification for this operation is necessary.
  let hasVerifier = 1;

  // Set the folder bit so that we can fold constant accesses.
  let hasFolder = 1;
}

//===----------------------------------------------------------------------===//
// StructConstantOp
//===----------------------------------------------------------------------===//

def StructConstantOp : Gazprea_Op<"struct_constant", [ConstantLike, Pure]> {
  let summary = "struct constant";
  let description = [{
    Constant operation turns a literal struct value into an SSA value. The data
    is attached to the operation as an attribute. The struct constant is encoded
    as an array of other constant values. For example:

    ```mlir
      %0 = gazprea.struct_constant [
             2048 : i32,
             0 : i1,
             255: i8
           ] : !gazprea.struct<i32, i1, i8>
    ```
  }];

  let arguments = (ins ArrayAttr:$value);
  let results = (outs Gazprea_StructType:$output);

  let assemblyFormat = "$value attr-dict `:` type($output)";

  // Indicate that additional verification for this operation is necessary.
  let hasVerifier = 1;
  let hasFolder = 1;
}

#endif // GAZPREA_OPS
