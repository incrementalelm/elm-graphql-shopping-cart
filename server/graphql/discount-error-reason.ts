import { enumType } from "nexus";

export const LookupErrorReasons = [
  {
    name: "EXPIRED",
    value: 1,
    description: "The discount has expired.",
    type: "DiscountedProductInfoOrError"
  },
  {
    name: "OVER_LIMIT",
    value: 2,
    description: "The discount has been used too many times.",
    type: "DiscountedProductInfoOrError"
  },
  {
    name: "NOTFOUND",
    value: 3,
    description:
      "The discount code does not exist. Note that discount codes are case sensitive.",
    type: "DiscountedProductInfoOrError"
  }
];

export const DiscountErrorReason = enumType({
  name: "DiscountErrorReason",
  description: "Reason that discount code cannot be applied.",
  members: LookupErrorReasons
});
