import { objectType } from "nexus";

export const DiscountNotFound = objectType({
  name: "DiscountNotFound",
  description: "The discount code does not exist.",
  definition(t) {
    t.int("ignore", {
      nullable: true
    });
  }
});
