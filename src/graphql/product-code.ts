import * as nexus from "nexus";

export const ProductCode = nexus.scalarType({
  name: "ProductCode",
  asNexusMethod: "productCode",
  description: "",
  parseValue(value: string) {
    return value;
  },
  serialize(value: string) {
    return value;
  },
  parseLiteral(value: string) {
    return value;
  }
});

// ({
//   name: "DiscountErrorReason",
//   description: "Reason that discount code cannot be applied.",
//   members: LookupErrorReasons
// });
