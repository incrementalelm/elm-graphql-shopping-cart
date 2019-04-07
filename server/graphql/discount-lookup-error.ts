import { objectType } from "nexus";

export const DiscountExpired = objectType({
  name: "DiscountExpired",
  description: "The discount code is no longer valid because it expired.",
  definition(t) {
    t.string("expiredAt", {
      nullable: false
    });
  }
});
