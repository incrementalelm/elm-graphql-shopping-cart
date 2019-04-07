# Rules of Thumb 👍

## The Pain Points Addressed by the Rules

### For `elm-ui`

- How do I re-use styles?
- How do I manage modal state?
- How do I do dropdowns?
- How do I do manage translations for the content/internationalization?
- How do I extract custom UI Elements?
  - Buttons?
- Forms?

### For `elm-graphql`

## Rules of Thumb 👍

### For `elm-ui`

- Keep every single style rule in a `UI.elm` module
- Modal state is handled globally (TODO: rule for how you handle the `Msg`s)

### For `elm-graphql`

- Use Scalars every time you are representing a semantic idea (could be as simple as a `Url`)
- Don't be afraid to use very specific Custom Scalars, like `ProductId` and `UserId` for example. The cost is low, the value is high
- Every Custom Scalar should be an Opaque Type which exposes `codec` (then use that codec in your CustomCodecs module)
  - If the Opaque Type is only created by `elm-graphql`, `codec` should be the only way to construct it.
  - If the Opaque Type needs to be created elsewhere, follow the principle _"Wrap early, unwrap late."_ For example, you should wrap into a `ProductId` scalar in your Url Parser if you are turning it into an Id there (instead of passing it around as a `String` through several functions). It should exist as a primitive for as short as possible.
