---
{
  "author": "Andres Otarola",
  "title": "✍🏽 Typed safe blogging",
  "description": "Did you ever wanted to know what would it feel to manage a typed safe static site? Spoilers: it's lovely 💚",
  "image": "v1627861555/elm-pages/article-covers/photo-1471107340929-a87cd0f5b5f3_mczjfg.jpg",
  "published": "2021-10-16",
}
---

## What?

Today begins my journey blogging about stuff; and what better than to do it about thing itself!.

## Why typed safe?

Well, I wanted to kinda click bait people, but I'm not completely fooling around :). I created this personal blog site using a brilliant tool called [`elm-pages`][elm-pages], which tool is made by a delightful language called [`elm`][elm]

[elm-pages]: https://elm-pages.com/
[elm]: https://elm-lang.org/

## What is elm?

Elm is a functional language that compiles to JavaScript, that introduces wild concept for people who are not used to
work with functional languages before. The most powerful feature of the language are the Types, which in short it lets
you leverage to the compiler to guide yourself

## How come is the blog type safe

here is some elm-code
```elm
rawText long =
  case long of
    ARIA -> 
      "st"
    BUCC ->
      "xs"
```
