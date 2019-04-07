import * as nexus from "nexus";

export const Dollars = nexus.scalarType({
  name: "Dollars",
  asNexusMethod: "dollars",
  description: "Cents in USD.",
  parseValue(value: number) {
    return value;
  },
  serialize(value: number) {
    return value;
  },
  parseLiteral(value: number) {
    return value;
  }
});
