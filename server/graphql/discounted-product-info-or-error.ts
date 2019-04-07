import * as nexus from "nexus";

export const DiscountedProductInfoOrError = nexus.unionType({
  name: "DiscountedProductInfoOrError",
  description:
    "The product information after applying a discount code. Or error info if it can't be applied.",
  definition(t) {
    t.members("DiscountExpired", "DiscountedProductInfo", "DiscountNotFound");
    t.resolveType((item: any) => item.type);
  }
});
