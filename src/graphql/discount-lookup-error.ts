import { objectType } from "nexus";

export const DiscountSuccessResponse = objectType({
  name: "DiscountedLookupError",
  description: "The product information after applying a discount code.",
  definition(t) {
    t.field("reason", {
      type: "DiscountErrorReason",
      nullable: false
    });
  }
});
